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

let _nr30_addr = 0xFF1A  (* Wave DAC enable - TODO *)
let _nr41_addr = 0xFF20  (* Noise length - TODO *)
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
}

(* Calculate samples per frame for default buffer sizing.
   At 60 FPS and 44100 Hz: samples_per_frame = 44100 / 60 = 735. *)
let samples_per_frame ~sample_rate ~sec_per_frame =
  int_of_float (float sample_rate *. sec_per_frame)

let create ?(sample_rate = default_sample_rate) ?(sec_per_frame = 1. /. 60.) ?buffer_size () =
  let buffer_size =
    Option.value buffer_size
      ~default:(samples_per_frame ~sample_rate ~sec_per_frame)
  in
  (* Calculate fixed-point cycles per sample:
     cycles_per_sample = (mcycles_per_second * timing_precision) / sample_rate *)
  let cycles_per_sample = Int64.(div (mul mcycles_per_second timing_precision) (of_int sample_rate)) in
  {
    square1 = Square_channel.create ~has_sweep:true;
    square2 = Square_channel.create ~has_sweep:false;
    sweep = Sweep.create ();
    frame_seq = Frame_sequencer.create ();
    wave_ram = Array.make 16 Uint8.zero;
    nr50 = Uint8.zero;
    nr51 = Uint8.zero;
    power_on = false;
    audio_buffer = Audio_buffer.create buffer_size;
    sample_counter = 0L;
    cycles_per_sample;
    sample_rate;
  }

(* Process frame sequencer events *)
let process_frame_events t events =
  List.iter (function
    | Frame_sequencer.Length ->
      Square_channel.clock_length t.square1;
      Square_channel.clock_length t.square2
    | Frame_sequencer.Envelope ->
      Square_channel.clock_envelope t.square1;
      Square_channel.clock_envelope t.square2
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

(* Mix all channels and return stereo sample.
   Each channel outputs 0-15, we sum and scale to 16-bit signed audio.

   NR51 controls panning:
   - Bits 0-3: Channels 1-4 to right output
   - Bits 4-7: Channels 1-4 to left output

   NR50 controls volume:
   - Bits 0-2: Right volume (0-7)
   - Bits 4-6: Left volume (0-7)

   The final sample is scaled to fit int16 range (-32768 to 32767).
   With 4 channels at 15 max volume each, max sum = 60 per side.
   After volume (8x max), max = 480.
   Scale factor to reach ~32767: 32767/480 ≈ 68.
   We use 64 for efficient multiplication. *)
let mix_sample t =
  let s1 = Square_channel.get_sample t.square1 in
  let s2 = Square_channel.get_sample t.square2 in
  let s3 = 0 in  (* Wave channel - TODO *)
  let s4 = 0 in  (* Noise channel - TODO *)

  let nr51 = Uint8.to_int t.nr51 in
  let nr50 = Uint8.to_int t.nr50 in

  (* Sum channels for each output based on NR51 panning *)
  let left =
    (if nr51 land 0x10 <> 0 then s1 else 0) +
    (if nr51 land 0x20 <> 0 then s2 else 0) +
    (if nr51 land 0x40 <> 0 then s3 else 0) +
    (if nr51 land 0x80 <> 0 then s4 else 0)
  in
  let right =
    (if nr51 land 0x01 <> 0 then s1 else 0) +
    (if nr51 land 0x02 <> 0 then s2 else 0) +
    (if nr51 land 0x04 <> 0 then s3 else 0) +
    (if nr51 land 0x08 <> 0 then s4 else 0)
  in

  (* Apply master volume from NR50 (each side 0-7, we use 1-8) *)
  let vol_left = ((nr50 lsr 4) land 0x07) + 1 in
  let vol_right = (nr50 land 0x07) + 1 in

  (* Scale to 16-bit signed range *)
  let scale = 64 in
  let left_out = (left * vol_left * scale) - 32768 in
  let right_out = (right * vol_right * scale) - 32768 in

  (* Clamp to int16 range *)
  let clamp v = max (-32768) (min 32767 v) in
  (clamp left_out, clamp right_out)

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
  let ch3 = 0 in  (* Wave channel - TODO *)
  let ch4 = 0 in  (* Noise channel - TODO *)
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

(* Reset all channels and registers *)
let power_off t =
  Square_channel.reset t.square1;
  Square_channel.reset t.square2;
  Sweep.reset t.sweep;
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
