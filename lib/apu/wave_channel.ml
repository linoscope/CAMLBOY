(* Wave Channel - plays back 32 4-bit samples from Wave RAM.

   The wave channel plays a custom waveform defined by 32 4-bit samples
   stored in Wave RAM (16 bytes at 0xFF30-0xFF3F). Each byte contains
   two samples: high nibble first, then low nibble.

   Frequency Timer:
   The sample position advances based on a countdown timer. The frequency
   register is 11 bits (0-2047), stored in NR33 (low 8 bits) and NR34 (high 3 bits).

   Timer period formula:
     period = (2048 - frequency) * 2 T-cycles

   This is half the period of square channels because wave reads a new sample
   every other T-cycle advance. In M-cycles (1 M-cycle = 4 T-cycles):
     period = (2048 - frequency) / 2 M-cycles

   Volume is set by NR32 bits 5-6:
   - 0: Mute (shift right 4, effectively 0)
   - 1: 100% (no shift)
   - 2: 50% (shift right 1)
   - 3: 25% (shift right 2)

   Reference: https://gbdev.gg8.se/wiki/articles/Gameboy_sound_hardware#Wave_Channel *)

(* The max frequency register value + 1. For 11-bit register, this is 2^11 = 2048. *)
let frequency_base = 2048

type t = {
  mutable dac_enabled : bool;     (* NR30 bit 7 *)
  mutable volume_code : int;      (* NR32 bits 5-6 *)
  mutable frequency : int;        (* 11-bit, 0-2047 *)
  mutable frequency_timer : int;  (* Counts down to advance position *)
  mutable position : int;         (* 0-31 sample position *)
  mutable sample_buffer : int;    (* Current sample (0-15) *)
  mutable enabled : bool;

  (* Wave RAM is stored externally in APU, we just get a reference *)
  length : Length_counter.t;
}

(* Calculate timer period from frequency.
   Wave channel period = (2048 - frequency) / 2 M-cycles.
   Minimum period is 1 to prevent infinite loops. *)
let timer_period frequency =
  max 1 ((frequency_base - frequency) / 2)

let create () = {
  dac_enabled = false;
  volume_code = 0;
  frequency = 0;
  frequency_timer = 0;
  position = 0;
  sample_buffer = 0;
  enabled = false;
  length = Length_counter.create ~max_length:256;
}

(* Get volume shift from volume code *)
let volume_shift = function
  | 0 -> 4  (* Mute *)
  | 1 -> 0  (* 100% *)
  | 2 -> 1  (* 50% *)
  | _ -> 2  (* 25% *)

(* Read current sample from wave RAM at current position *)
let read_sample_from_ram wave_ram position =
  let byte_index = position / 2 in
  let byte = Uints.Uint8.to_int wave_ram.(byte_index) in
  if position mod 2 = 0 then
    (byte lsr 4) land 0x0F  (* High nibble first *)
  else
    byte land 0x0F  (* Then low nibble *)

(* Run the channel for given M-cycles, advancing sample position *)
let run t ~wave_ram ~mcycles =
  if not t.enabled then
    ()
  else begin
    t.frequency_timer <- t.frequency_timer - mcycles;
    while t.frequency_timer <= 0 do
      t.frequency_timer <- t.frequency_timer + timer_period t.frequency;
      t.position <- (t.position + 1) land 31;
      t.sample_buffer <- read_sample_from_ram wave_ram t.position
    done
  end

(* Get current output sample (0-15, after volume adjustment) *)
let get_sample t =
  if not t.enabled || not t.dac_enabled then
    0
  else
    t.sample_buffer lsr (volume_shift t.volume_code)

(* Clock length counter. Called by frame sequencer. *)
let clock_length t =
  if Length_counter.clock t.length then
    t.enabled <- false

(* Trigger the channel (NR34 bit 7 written)

   Obscure behavior: When triggering, the sample_buffer is NOT updated.
   The first sample played is whatever was previously in the buffer.
   The new position 0 sample isn't read until the waveform advances.
   Reference: https://gbdev.gg8.se/wiki/articles/Gameboy_sound_hardware#Trigger_Event *)
let trigger t ~wave_ram:_ ~next_step_clocks_length =
  t.enabled <- t.dac_enabled;
  Length_counter.trigger t.length ~next_step_clocks_length;
  t.frequency_timer <- timer_period t.frequency;
  t.position <- 0
  (* Note: sample_buffer intentionally NOT updated - keeps previous value *)

(* Check if channel is enabled *)
let is_enabled t = t.enabled

(* Setters for register writes *)
let set_dac_enabled t enabled =
  t.dac_enabled <- enabled;
  if not enabled then
    t.enabled <- false

let set_volume_code t code =
  t.volume_code <- code land 0x03

let set_frequency t frequency =
  t.frequency <- frequency land 0x7FF  (* 11 bits *)

let set_enabled t enabled =
  t.enabled <- enabled

(* Getters *)
let get_dac_enabled t = t.dac_enabled
let get_volume_code t = t.volume_code
let get_frequency t = t.frequency
let get_length t = t.length

(* Reset the channel *)
let reset t =
  t.dac_enabled <- false;
  t.volume_code <- 0;
  t.frequency <- 0;
  t.frequency_timer <- 0;
  t.position <- 0;
  t.sample_buffer <- 0;
  t.enabled <- false;
  Length_counter.reset t.length
