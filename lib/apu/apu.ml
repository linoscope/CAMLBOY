(* Audio Processing Unit (APU) implementation.
   Reference: https://gbdev.gg8.se/wiki/articles/Gameboy_sound_hardware *)

open Uints


(* Audio timing constants.
   CPU runs at 4194304 Hz (T-cycles), 1 M-cycle = 4 T-cycles.
   We generate audio samples at a configurable rate (default 44100 Hz).

   M-cycles per second = 4194304 / 4 = 1048576
   M-cycles per sample = 1048576 / sample_rate

   For 44100 Hz: 1048576 / 44100 ≈ 23.78 M-cycles per sample.
   We use fixed-point math with Int64 to handle the fractional part accurately
   and avoid integer overflow in js_of_ocaml (which uses 32-bit ints). *)
let default_sample_rate = 44100
let mcycles_per_second = Int64.of_int Constants.mcycles_per_second

(* Fixed-point precision for sample timing (16 bits of fraction) *)
let timing_precision = 65536L

(* APU register addresses *)
let nr10_addr = 0xFF10  (* Square 1 sweep *)
let nr11_addr = 0xFF11  (* Square 1 duty/length *)
let nr12_addr = 0xFF12  (* Square 1 envelope *)
let nr13_addr = 0xFF13  (* Square 1 frequency low *)
let nr14_addr = 0xFF14  (* Square 1 frequency high / control *)

let nr21_addr = 0xFF16  (* Square 2 duty/length *)
let nr22_addr = 0xFF17  (* Square 2 envelope *)
let nr23_addr = 0xFF18  (* Square 2 frequency low *)
let nr24_addr = 0xFF19  (* Square 2 frequency high / control *)

let nr30_addr = 0xFF1A  (* Wave DAC enable *)
let nr31_addr = 0xFF1B  (* Wave length *)
let nr32_addr = 0xFF1C  (* Wave volume *)
let nr33_addr = 0xFF1D  (* Wave frequency low *)
let nr34_addr = 0xFF1E  (* Wave frequency high / control *)

let nr41_addr = 0xFF20  (* Noise length *)
let nr42_addr = 0xFF21  (* Noise envelope *)
let nr43_addr = 0xFF22  (* Noise polynomial counter *)
let nr44_addr = 0xFF23  (* Noise control *)

let nr50_addr = 0xFF24  (* Master volume *)
let nr51_addr = 0xFF25  (* Sound panning *)
let nr52_addr = 0xFF26  (* Sound on/off *)

let wave_ram_start = 0xFF30
let wave_ram_end = 0xFF3F

type t = {
  (* Sound channels *)
  square1 : Square_channel.t;
  square2 : Square_channel.t;
  sweep : Sweep.t;  (* For Square 1 *)
  wave : Wave_channel.t;
  noise : Noise_channel.t;

  (* Frame sequencer drives length/envelope/sweep clocking *)
  frame_seq : Frame_sequencer.t;

  (* Wave RAM: 16 bytes = 32 4-bit samples (for wave channel) *)
  wave_ram : uint8 array;

  (* Master control registers *)
  mutable nr50 : uint8;  (* Master volume & Vin *)
  mutable nr51 : uint8;  (* Sound panning *)
  mutable power_on : bool;

  (* Audio output *)
  audio_buffer : Audio_buffer.t;
  mutable sample_counter : int64;  (* Fixed-point counter for sample timing *)
  cycles_per_sample : int64;       (* Fixed-point M-cycles per sample *)
  sample_rate : int;
  use_blep : bool;  (* Use band-limited synthesis for square channels *)
}

(* Calculate samples per frame for default buffer sizing.
   At 60 FPS and 44100 Hz: samples_per_frame = 44100 / 60 = 735. *)
let samples_per_frame ~sample_rate ~sec_per_frame =
  int_of_float (float sample_rate *. sec_per_frame)

let create
    ?(sample_rate = default_sample_rate)
    ?(sec_per_frame = 1. /. 60.)
    ?buffer_size
    ?(use_blep = true)
    () =
  let buffer_size =
    Option.value buffer_size
      ~default:(samples_per_frame ~sample_rate ~sec_per_frame)
  in
  (* Calculate fixed-point cycles per sample:
     cycles_per_sample = (mcycles_per_second * timing_precision) / sample_rate *)
  let cycles_per_sample =
    Int64.(div (mul mcycles_per_second timing_precision) (of_int sample_rate))
  in
  {
    square1 = Square_channel.create ~has_sweep:true;
    square2 = Square_channel.create ~has_sweep:false;
    sweep = Sweep.create ();
    wave = Wave_channel.create ();
    noise = Noise_channel.create ();
    frame_seq = Frame_sequencer.create ();
    wave_ram = Array.make 16 Uint8.zero;
    nr50 = Uint8.zero;
    nr51 = Uint8.zero;
    power_on = false;
    audio_buffer = Audio_buffer.create buffer_size;
    sample_counter = 0L;
    cycles_per_sample;
    sample_rate;
    use_blep;
  }

(* Process frame sequencer events *)
let process_frame_events t events =
  List.iter (function
    | Frame_sequencer.Length ->
      Square_channel.clock_length t.square1;
      Square_channel.clock_length t.square2;
      Wave_channel.clock_length t.wave;
      Noise_channel.clock_length t.noise
    | Frame_sequencer.Envelope ->
      Square_channel.clock_envelope t.square1;
      Square_channel.clock_envelope t.square2;
      (* Wave channel has no envelope *)
      Noise_channel.clock_envelope t.noise
    | Frame_sequencer.Sweep ->
      let (new_freq_opt, should_disable) = Sweep.clock t.sweep in
      if should_disable then
        Square_channel.set_enabled t.square1 false
      else
        match new_freq_opt with
        | Some new_freq ->
          Square_channel.set_frequency t.square1 new_freq;
          Sweep.set_shadow_frequency t.sweep new_freq
        | None -> ()
  ) events

let mix_sample t =
  let mix = if t.use_blep then Mixer.Blep.mix else Mixer.Naive.mix in
  mix
    ~square1:t.square1 ~square2:t.square2
    ~wave:t.wave ~noise:t.noise
    ~nr50:t.nr50 ~nr51:t.nr51
    ~sample_rate:t.sample_rate

(* Generate audio samples based on elapsed cycles *)
let generate_samples t ~mcycles =
  (* Add cycles to counter (in fixed-point) *)
  t.sample_counter <- Int64.(add t.sample_counter (mul (of_int mcycles) timing_precision));

  (* Generate samples while we have accumulated enough cycles *)
  while t.sample_counter >= t.cycles_per_sample do
    t.sample_counter <- Int64.sub t.sample_counter t.cycles_per_sample;
    let (left, right) = mix_sample t in
    (* If buffer is full, samples are dropped (audio underrun protection) *)
    let _ = Audio_buffer.push t.audio_buffer ~left ~right in
    ()
  done

let run t ~mcycles =
  if not t.power_on then begin
    (* Even when powered off, generate silent samples to keep audio flowing *)
    generate_samples t ~mcycles
  end else begin
    (* Run frame sequencer and process events *)
    let events = Frame_sequencer.run t.frame_seq ~mcycles in
    process_frame_events t events;

    (* Run channels *)
    Square_channel.run t.square1 ~mcycles;
    Square_channel.run t.square2 ~mcycles;
    Wave_channel.run t.wave ~wave_ram:t.wave_ram ~mcycles;
    Noise_channel.run t.noise ~mcycles;

    (* Generate audio samples *)
    generate_samples t ~mcycles
  end

let accepts _t addr =
  let a = Uint16.to_int addr in
  (a >= nr10_addr && a <= nr52_addr) || (a >= wave_ram_start && a <= wave_ram_end)

(* Read NR52 - sound on/off and channel status *)
let read_nr52 t =
  let ch1 = if Square_channel.is_enabled t.square1 then 0x01 else 0 in
  let ch2 = if Square_channel.is_enabled t.square2 then 0x02 else 0 in
  let ch3 = if Wave_channel.is_enabled t.wave then 0x04 else 0 in
  let ch4 = if Noise_channel.is_enabled t.noise then 0x08 else 0 in
  let power = if t.power_on then 0x80 else 0 in
  (* Bits 4-6 are unused and read as 1 *)
  Uint8.of_int (0x70 lor power lor ch4 lor ch3 lor ch2 lor ch1)

let read_byte t addr =
  let a = Uint16.to_int addr in
  if a >= wave_ram_start && a <= wave_ram_end then
    t.wave_ram.(a - wave_ram_start)
  else match a with
    (* Square 1 registers *)
    | _ when a = nr10_addr ->
      let sw = t.sweep in
      Uint8.of_int (
        0x80 lor  (* Bit 7 unused, reads as 1 *)
        ((Sweep.get_period sw) lsl 4) lor
        (if Sweep.get_negate sw then 0x08 else 0) lor
        (Sweep.get_shift sw)
      )
    | _ when a = nr11_addr ->
      (* Only bits 7-6 (duty) are readable *)
      Uint8.of_int (0x3F lor ((Square_channel.int_of_duty (Square_channel.get_duty t.square1)) lsl 6))
    | _ when a = nr12_addr ->
      let env = Square_channel.get_envelope t.square1 in
      Uint8.of_int (
        ((Envelope.get_volume env) lsl 4) lor
        (if Envelope.get_direction env = Envelope.Up then 0x08 else 0) lor
        (Envelope.get_period env)
      )
    | _ when a = nr13_addr ->
      (* Write-only, reads as 0xFF *)
      Uint8.of_int 0xFF
    | _ when a = nr14_addr ->
      (* Only bit 6 (length enable) is readable *)
      let len = Square_channel.get_length t.square1 in
      Uint8.of_int (0xBF lor (if Length_counter.is_enabled len then 0x40 else 0))

    (* Square 2 registers *)
    | _ when a = nr21_addr ->
      Uint8.of_int (0x3F lor ((Square_channel.int_of_duty (Square_channel.get_duty t.square2)) lsl 6))
    | _ when a = nr22_addr ->
      let env = Square_channel.get_envelope t.square2 in
      Uint8.of_int (
        ((Envelope.get_volume env) lsl 4) lor
        (if Envelope.get_direction env = Envelope.Up then 0x08 else 0) lor
        (Envelope.get_period env)
      )
    | _ when a = nr23_addr ->
      Uint8.of_int 0xFF
    | _ when a = nr24_addr ->
      let len = Square_channel.get_length t.square2 in
      Uint8.of_int (0xBF lor (if Length_counter.is_enabled len then 0x40 else 0))

    (* Wave channel registers *)
    | _ when a = nr30_addr ->
      (* NR30: bit 7 = DAC enable, bits 6-0 unused (read as 1) *)
      Uint8.of_int (0x7F lor (if Wave_channel.get_dac_enabled t.wave then 0x80 else 0))
    | _ when a = nr31_addr ->
      (* NR31: Write-only, reads as 0xFF *)
      Uint8.of_int 0xFF
    | _ when a = nr32_addr ->
      (* NR32: bits 6-5 = volume, rest unused (read as 1) *)
      Uint8.of_int (0x9F lor ((Wave_channel.get_volume_code t.wave) lsl 5))
    | _ when a = nr33_addr ->
      (* NR33: Write-only, reads as 0xFF *)
      Uint8.of_int 0xFF
    | _ when a = nr34_addr ->
      (* NR34: bit 6 = length enable, rest unused/write-only (read as 1) *)
      let len = Wave_channel.get_length t.wave in
      Uint8.of_int (0xBF lor (if Length_counter.is_enabled len then 0x40 else 0))

    (* Noise channel registers *)
    | _ when a = nr41_addr ->
      (* NR41: Write-only, reads as 0xFF *)
      Uint8.of_int 0xFF
    | _ when a = nr42_addr ->
      (* NR42: Envelope register, fully readable *)
      let env = Noise_channel.get_envelope t.noise in
      Uint8.of_int (
        ((Envelope.get_volume env) lsl 4) lor
        (if Envelope.get_direction env = Envelope.Up then 0x08 else 0) lor
        (Envelope.get_period env)
      )
    | _ when a = nr43_addr ->
      (* NR43: Polynomial counter, fully readable *)
      Uint8.of_int (
        ((Noise_channel.get_clock_shift t.noise) lsl 4) lor
        (if Noise_channel.get_width_mode t.noise then 0x08 else 0) lor
        (Noise_channel.get_divisor_code t.noise)
      )
    | _ when a = nr44_addr ->
      (* NR44: bit 6 = length enable, rest unused/write-only (read as 1) *)
      let len = Noise_channel.get_length t.noise in
      Uint8.of_int (0xBF lor (if Length_counter.is_enabled len then 0x40 else 0))

    (* Master control *)
    | _ when a = nr50_addr -> t.nr50
    | _ when a = nr51_addr -> t.nr51
    | _ when a = nr52_addr -> read_nr52 t

    (* Unimplemented or write-only registers *)
    | _ -> Uint8.of_int 0xFF

(* Write to Square 1 registers *)
let write_square1 t addr data =
  let d = Uint8.to_int data in
  match addr with
  | _ when addr = nr10_addr ->
    let old_negate = Sweep.get_negate t.sweep in
    Sweep.load_from_register t.sweep ~register_value:d;
    (* Check for obscure negate->positive disable *)
    let new_negate = Sweep.get_negate t.sweep in
    if Sweep.check_negate_to_positive_switch t.sweep ~new_negate && not new_negate && old_negate then
      Square_channel.set_enabled t.square1 false

  | _ when addr = nr11_addr ->
    Square_channel.set_duty t.square1 (Square_channel.duty_of_int ((d lsr 6) land 0x03));
    let len = Square_channel.get_length t.square1 in
    Length_counter.load_from_register len ~register_value:(d land 0x3F)

  | _ when addr = nr12_addr ->
    let env = Square_channel.get_envelope t.square1 in
    Envelope.load_from_register env ~register_value:d;
    Square_channel.update_dac t.square1

  | _ when addr = nr13_addr ->
    let freq = Square_channel.get_frequency t.square1 in
    Square_channel.set_frequency t.square1 ((freq land 0x700) lor d)

  | _ when addr = nr14_addr ->
    let freq = Square_channel.get_frequency t.square1 in
    Square_channel.set_frequency t.square1 ((freq land 0xFF) lor ((d land 0x07) lsl 8));
    let len = Square_channel.get_length t.square1 in
    Length_counter.set_enabled len ((d land 0x40) <> 0);
    (* Trigger *)
    if (d land 0x80) <> 0 then begin
      Square_channel.trigger t.square1;
      let overflow = Sweep.trigger t.sweep ~frequency:(Square_channel.get_frequency t.square1) in
      if overflow then
        Square_channel.set_enabled t.square1 false
    end

  | _ -> ()

(* Write to Square 2 registers *)
let write_square2 t addr data =
  let d = Uint8.to_int data in
  match addr with
  | _ when addr = nr21_addr ->
    Square_channel.set_duty t.square2 (Square_channel.duty_of_int ((d lsr 6) land 0x03));
    let len = Square_channel.get_length t.square2 in
    Length_counter.load_from_register len ~register_value:(d land 0x3F)

  | _ when addr = nr22_addr ->
    let env = Square_channel.get_envelope t.square2 in
    Envelope.load_from_register env ~register_value:d;
    Square_channel.update_dac t.square2

  | _ when addr = nr23_addr ->
    let freq = Square_channel.get_frequency t.square2 in
    Square_channel.set_frequency t.square2 ((freq land 0x700) lor d)

  | _ when addr = nr24_addr ->
    let freq = Square_channel.get_frequency t.square2 in
    Square_channel.set_frequency t.square2 ((freq land 0xFF) lor ((d land 0x07) lsl 8));
    let len = Square_channel.get_length t.square2 in
    Length_counter.set_enabled len ((d land 0x40) <> 0);
    (* Trigger *)
    if (d land 0x80) <> 0 then
      Square_channel.trigger t.square2

  | _ -> ()

(* Write to Wave channel registers *)
let write_wave t addr data =
  let d = Uint8.to_int data in
  match addr with
  | _ when addr = nr30_addr ->
    Wave_channel.set_dac_enabled t.wave ((d land 0x80) <> 0)

  | _ when addr = nr31_addr ->
    let len = Wave_channel.get_length t.wave in
    Length_counter.load_from_register len ~register_value:d

  | _ when addr = nr32_addr ->
    Wave_channel.set_volume_code t.wave ((d lsr 5) land 0x03)

  | _ when addr = nr33_addr ->
    let freq = Wave_channel.get_frequency t.wave in
    Wave_channel.set_frequency t.wave ((freq land 0x700) lor d)

  | _ when addr = nr34_addr ->
    let freq = Wave_channel.get_frequency t.wave in
    Wave_channel.set_frequency t.wave ((freq land 0xFF) lor ((d land 0x07) lsl 8));
    let len = Wave_channel.get_length t.wave in
    Length_counter.set_enabled len ((d land 0x40) <> 0);
    (* Trigger *)
    if (d land 0x80) <> 0 then
      Wave_channel.trigger t.wave ~wave_ram:t.wave_ram

  | _ -> ()

(* Write to Noise channel registers *)
let write_noise t addr data =
  let d = Uint8.to_int data in
  match addr with
  | _ when addr = nr41_addr ->
    let len = Noise_channel.get_length t.noise in
    Length_counter.load_from_register len ~register_value:(d land 0x3F)

  | _ when addr = nr42_addr ->
    let env = Noise_channel.get_envelope t.noise in
    Envelope.load_from_register env ~register_value:d;
    Noise_channel.update_dac t.noise

  | _ when addr = nr43_addr ->
    Noise_channel.set_clock_shift t.noise ((d lsr 4) land 0x0F);
    Noise_channel.set_width_mode t.noise ((d land 0x08) <> 0);
    Noise_channel.set_divisor_code t.noise (d land 0x07)

  | _ when addr = nr44_addr ->
    let len = Noise_channel.get_length t.noise in
    Length_counter.set_enabled len ((d land 0x40) <> 0);
    (* Trigger *)
    if (d land 0x80) <> 0 then
      Noise_channel.trigger t.noise

  | _ -> ()

(* Reset all channels and registers *)
let power_off t =
  Square_channel.reset t.square1;
  Square_channel.reset t.square2;
  Sweep.reset t.sweep;
  Wave_channel.reset t.wave;
  Noise_channel.reset t.noise;
  Frame_sequencer.reset t.frame_seq;
  t.nr50 <- Uint8.zero;
  t.nr51 <- Uint8.zero

let write_byte t ~addr ~data =
  let a = Uint16.to_int addr in
  if a >= wave_ram_start && a <= wave_ram_end then
    t.wave_ram.(a - wave_ram_start) <- data
  else if a = nr52_addr then begin
    (* NR52: only bit 7 (power) is writable *)
    let new_power = Uint8.to_int data land 0x80 <> 0 in
    if t.power_on && not new_power then
      power_off t;
    t.power_on <- new_power
  end else if t.power_on then begin
    (* Only allow writes when powered on *)
    match a with
    | _ when a >= nr10_addr && a <= nr14_addr ->
      write_square1 t a data
    | _ when a >= nr21_addr && a <= nr24_addr ->
      write_square2 t a data
    | _ when a >= nr30_addr && a <= nr34_addr ->
      write_wave t a data
    | _ when a >= nr41_addr && a <= nr44_addr ->
      write_noise t a data
    | _ when a = nr50_addr ->
      t.nr50 <- data
    | _ when a = nr51_addr ->
      t.nr51 <- data
    | _ -> ()
  end

(* Audio buffer access for SDL2 callback *)

(* Get the audio buffer (for direct access in callback) *)
let get_audio_buffer t = t.audio_buffer

(* Get number of samples available in buffer *)
let samples_available t = Audio_buffer.available t.audio_buffer

(* Pop a single sample from the buffer *)
let pop_sample t = Audio_buffer.pop t.audio_buffer

(* Pop multiple samples into bigarray. Returns number of samples read.
   This is the main interface for the SDL2 audio callback.
   Destination should be interleaved stereo (L R L R ...). *)
let pop_samples t ~dst ~count =
  Audio_buffer.pop_into t.audio_buffer ~dst ~count

(* Get the audio buffer capacity *)
let buffer_capacity t = Audio_buffer.capacity t.audio_buffer

(* Get the sample rate *)
let sample_rate t = t.sample_rate
