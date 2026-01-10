(* Noise Channel - generates pseudo-random noise using a Linear Feedback Shift Register (LFSR).

   The noise channel produces a pseudo-random bit sequence that sounds like white
   or metallic noise depending on configuration. It uses a 15-bit or 7-bit LFSR.

   LFSR operation:
   - XOR bits 0 and 1 of the shift register
   - Shift the register right by 1
   - Put the XOR result in bit 14 (and optionally bit 6 for 7-bit mode)
   - Output is the inverted bit 0

   Frequency is controlled by a polynomial counter (NR43):
   - Bits 7-4: Clock shift (s)
   - Bit 3: Width mode (0 = 15-bit, 1 = 7-bit)
   - Bits 2-0: Divisor code (r)

   Timer period = divisor[r] << s
   Where divisor[0..7] = [8, 16, 32, 48, 64, 80, 96, 112]

   7-bit mode produces a more metallic/buzzy sound, while 15-bit mode
   produces white noise.

   Reference: https://gbdev.gg8.se/wiki/articles/Gameboy_sound_hardware#Noise_Channel *)

(* Divisor table for polynomial counter *)
let divisors = [| 8; 16; 32; 48; 64; 80; 96; 112 |]

type t = {
  mutable lfsr : int;             (* 15-bit shift register *)
  mutable width_mode : bool;      (* true = 7-bit, false = 15-bit *)
  mutable clock_shift : int;      (* NR43 bits 7-4 *)
  mutable divisor_code : int;     (* NR43 bits 2-0 *)
  mutable frequency_timer : int;  (* Counts down to clock LFSR *)
  mutable enabled : bool;
  mutable dac_enabled : bool;

  length : Length_counter.t;
  envelope : Envelope.t;
}

(* Calculate timer period from clock shift and divisor code *)
let timer_period ~clock_shift ~divisor_code =
  let divisor = divisors.(divisor_code) in
  (* Minimum period of 1 to prevent infinite loops *)
  max 1 (divisor lsl clock_shift)

let create () = {
  lfsr = 0x7FFF;  (* All 1s initially *)
  width_mode = false;
  clock_shift = 0;
  divisor_code = 0;
  frequency_timer = 0;
  enabled = false;
  dac_enabled = false;
  length = Length_counter.create ~max_length:64;
  envelope = Envelope.create ();
}

(* Clock the LFSR once *)
let clock_lfsr t =
  (* XOR bits 0 and 1 *)
  let xor_result = (t.lfsr land 1) lxor ((t.lfsr lsr 1) land 1) in
  (* Shift right by 1 *)
  t.lfsr <- t.lfsr lsr 1;
  (* Put XOR result in bit 14 *)
  t.lfsr <- t.lfsr lor (xor_result lsl 14);
  (* If 7-bit mode, also put XOR result in bit 6 *)
  if t.width_mode then
    t.lfsr <- (t.lfsr land (lnot 0x40)) lor (xor_result lsl 6)

(* Run the channel for given M-cycles.

   Obscure behavior: Using clock shift 14 or 15 results in the LFSR
   receiving no clocks, producing a static output.
   Reference: https://gbdev.gg8.se/wiki/articles/Gameboy_sound_hardware#Noise_Channel *)
let run t ~mcycles =
  if not t.enabled then
    ()
  (* Clock shift 14-15: LFSR receives no clocks *)
  else if t.clock_shift >= 14 then
    ()
  else begin
    t.frequency_timer <- t.frequency_timer - mcycles;
    while t.frequency_timer <= 0 do
      t.frequency_timer <- t.frequency_timer +
        timer_period ~clock_shift:t.clock_shift ~divisor_code:t.divisor_code;
      clock_lfsr t
    done
  end

(* Get current output sample (0-15) *)
let get_sample t =
  if not t.enabled || not t.dac_enabled then
    0
  else begin
    (* Output is inverted bit 0 of LFSR, multiplied by volume *)
    let output_bit = (lnot t.lfsr) land 1 in
    output_bit * Envelope.get_volume t.envelope
  end

(* Clock length counter. Called by frame sequencer. *)
let clock_length t =
  if Length_counter.clock t.length then
    t.enabled <- false

(* Clock envelope. Called by frame sequencer. *)
let clock_envelope t =
  Envelope.clock t.envelope

(* Trigger the channel (NR44 bit 7 written) *)
let trigger t =
  t.enabled <- t.dac_enabled;
  Length_counter.trigger t.length;
  Envelope.trigger t.envelope;
  t.frequency_timer <- timer_period ~clock_shift:t.clock_shift ~divisor_code:t.divisor_code;
  (* Reset LFSR to all 1s *)
  t.lfsr <- 0x7FFF

(* Check if channel is enabled *)
let is_enabled t = t.enabled

(* Update DAC status (from NR42 register) *)
let update_dac t =
  t.dac_enabled <- Envelope.is_dac_enabled t.envelope;
  if not t.dac_enabled then
    t.enabled <- false

(* Setters for register writes *)
let set_clock_shift t shift =
  t.clock_shift <- shift land 0x0F

let set_width_mode t mode =
  t.width_mode <- mode

let set_divisor_code t code =
  t.divisor_code <- code land 0x07

let set_enabled t enabled =
  t.enabled <- enabled

(* Getters *)
let get_clock_shift t = t.clock_shift
let get_width_mode t = t.width_mode
let get_divisor_code t = t.divisor_code
let get_length t = t.length
let get_envelope t = t.envelope

(* Reset the channel *)
let reset t =
  t.lfsr <- 0x7FFF;
  t.width_mode <- false;
  t.clock_shift <- 0;
  t.divisor_code <- 0;
  t.frequency_timer <- 0;
  t.enabled <- false;
  t.dac_enabled <- false;
  Length_counter.reset t.length;
  Envelope.reset t.envelope
