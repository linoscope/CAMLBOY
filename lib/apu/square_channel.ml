(* Square Wave Channel - generates pulse waves with configurable duty cycle.

   The square channels produce a pulse wave with one of four duty cycles:
   - 12.5% (1/8 high): _______X
   - 25%   (2/8 high): X______X
   - 50%   (4/8 high): X___XXXX (actually XXXX___X)
   - 75%   (6/8 high): _XXXXXX_

   Frequency Timer:
   The waveform position advances based on a countdown timer. The frequency
   register is 11 bits (0-2047), stored in NRx3 (low 8 bits) and NRx4 (high 3 bits).

   Timer period formula (from Game Boy hardware):
     period = (2048 - frequency) * 4 T-cycles

   Where 2048 = 2^11, one more than the max 11-bit frequency value.
   This means:
   - frequency=0    -> period=8192 T-cycles (lowest pitch, ~512 Hz)
   - frequency=2047 -> period=4 T-cycles    (highest pitch, ~1 MHz)

   Since 1 M-cycle = 4 T-cycles, in M-cycles:
     period = (2048 - frequency) M-cycles

   Reference: https://gbdev.gg8.se/wiki/articles/Gameboy_sound_hardware#Square_Wave *)

type duty =
  | Duty_12_5  (* 12.5% duty cycle *)
  | Duty_25    (* 25% duty cycle *)
  | Duty_50    (* 50% duty cycle *)
  | Duty_75    (* 75% duty cycle *)

(* Duty waveforms - 1 = high, 0 = low *)
let duty_table = function
  | Duty_12_5 -> [| 0; 0; 0; 0; 0; 0; 0; 1 |]
  | Duty_25   -> [| 1; 0; 0; 0; 0; 0; 0; 1 |]
  | Duty_50   -> [| 1; 0; 0; 0; 0; 1; 1; 1 |]
  | Duty_75   -> [| 0; 1; 1; 1; 1; 1; 1; 0 |]

let duty_of_int = function
  | 0 -> Duty_12_5
  | 1 -> Duty_25
  | 2 -> Duty_50
  | 3 -> Duty_75
  | _ -> Duty_50  (* Default *)

let int_of_duty = function
  | Duty_12_5 -> 0
  | Duty_25 -> 1
  | Duty_50 -> 2
  | Duty_75 -> 3

type t = {
  (* Waveform generation *)
  mutable duty : duty;
  mutable frequency : int;        (* 11-bit, 0-2047 *)
  mutable frequency_timer : int;  (* Counts down to advance position *)
  mutable duty_position : int;    (* 0-7 position in duty table *)

  (* Channel state *)
  mutable enabled : bool;
  mutable dac_enabled : bool;

  (* Modulation units *)
  length : Length_counter.t;
  envelope : Envelope.t;

  (* Whether this channel has sweep (Square 1 only) *)
  has_sweep : bool;
}

(* The max frequency register value + 1. For 11-bit register, this is 2^11 = 2048.
   This is the base value from which frequency is subtracted to get timer period. *)
let frequency_base = 2048

(* Calculate timer period from frequency in M-cycles.
   Period = (frequency_base - frequency) M-cycles.
   Minimum period of 1 to prevent infinite loops. *)
let timer_period frequency =
  max 1 (frequency_base - frequency)

let create ~has_sweep = {
  duty = Duty_50;
  frequency = 0;
  frequency_timer = 0;
  duty_position = 0;
  enabled = false;
  dac_enabled = false;
  length = Length_counter.create ~max_length:64;
  envelope = Envelope.create ();
  has_sweep;
}

(* Run the channel for given M-cycles, advancing waveform position *)
let run t ~mcycles =
  if not t.enabled then
    ()
  else begin
    t.frequency_timer <- t.frequency_timer - mcycles;
    while t.frequency_timer <= 0 do
      t.frequency_timer <- t.frequency_timer + timer_period t.frequency;
      t.duty_position <- (t.duty_position + 1) land 7
    done
  end

(* Get current output sample (0-15) *)
let get_sample t =
  if not t.enabled || not t.dac_enabled then
    0
  else begin
    let waveform = (duty_table t.duty).(t.duty_position) in
    waveform * Envelope.get_volume t.envelope
  end

(* Clock length counter. Called by frame sequencer. *)
let clock_length t =
  if Length_counter.clock t.length then
    t.enabled <- false

(* Clock envelope. Called by frame sequencer. *)
let clock_envelope t =
  Envelope.clock t.envelope

(* Trigger the channel (NRx4 bit 7 written) *)
let trigger t =
  t.enabled <- t.dac_enabled;
  Length_counter.trigger t.length;
  Envelope.trigger t.envelope;
  t.frequency_timer <- timer_period t.frequency;
  t.duty_position <- 0

(* Check if channel is enabled *)
let is_enabled t = t.enabled

(* Setters for register writes *)
let set_duty t duty =
  t.duty <- duty

let set_frequency t frequency =
  t.frequency <- frequency land 0x7FF  (* 11 bits *)

let set_length_enabled t enabled =
  Length_counter.set_enabled t.length enabled

let set_enabled t enabled =
  t.enabled <- enabled

(* Update DAC status (from NRx2 register) *)
let update_dac t =
  t.dac_enabled <- Envelope.is_dac_enabled t.envelope;
  if not t.dac_enabled then
    t.enabled <- false

(* Getters *)
let get_duty t = t.duty
let get_frequency t = t.frequency
let get_length t = t.length
let get_envelope t = t.envelope
let has_sweep t = t.has_sweep

(* Hardware state accessors for Blep.HARDWARE signature *)
let duty_position t = t.duty_position
let duty_steps = 8
let frequency_timer t = t.frequency_timer
let timer_period t = timer_period t.frequency
let duty_ratio t = match t.duty with
  | Duty_12_5 -> 0.125 | Duty_25 -> 0.25
  | Duty_50 -> 0.5     | Duty_75 -> 0.75
let output t = (duty_table t.duty).(t.duty_position)
let volume t = Envelope.get_volume t.envelope
let is_active t = t.enabled && t.dac_enabled

(* Reset the channel *)
let reset t =
  t.duty <- Duty_50;
  t.frequency <- 0;
  t.frequency_timer <- 0;
  t.duty_position <- 0;
  t.enabled <- false;
  t.dac_enabled <- false;
  Length_counter.reset t.length;
  Envelope.reset t.envelope
