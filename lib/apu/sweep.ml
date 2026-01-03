(* Frequency Sweep - automatically modulates the frequency of Square 1.

   The sweep is clocked at 128 Hz by the frame sequencer (steps 2 and 6).
   It can increase or decrease the frequency over time, creating effects
   like rising/falling tones or vibrato.

   Register format (NR10 at 0xFF10):
   - Bits 6-4: Period (0-7, 0 means sweep is disabled)
   - Bit 3: Direction (0 = increase, 1 = decrease/negate)
   - Bits 2-0: Shift (0-7)

   Frequency calculation:
     new_frequency = shadow_frequency +/- (shadow_frequency >> shift)

   If new_frequency > 2047 (11-bit max), the channel is disabled.

   The sweep uses a "shadow register" that holds a copy of the frequency.
   This shadow is updated during sweep calculations and can overflow check
   even when the sweep is not actively changing frequency.

   Reference: https://gbdev.gg8.se/wiki/articles/Gameboy_sound_hardware#Frequency_Sweep *)

(* The max valid frequency + 1. Frequencies >= this cause overflow/disable. *)
let frequency_max = 2048

type t = {
  mutable shadow_frequency : int;  (* Copy of channel frequency *)
  mutable timer : int;             (* Counts down to next sweep *)
  mutable enabled : bool;          (* Whether sweep is active *)
  mutable period : int;            (* 0-7, how often to sweep *)
  mutable negate : bool;           (* true = decrease frequency *)
  mutable shift : int;             (* 0-7, how much to shift *)
  mutable negate_used : bool;      (* Tracks if negate mode was used *)
}

let create () = {
  shadow_frequency = 0;
  timer = 0;
  enabled = false;
  period = 0;
  negate = false;
  shift = 0;
  negate_used = false;
}

(* Calculate new frequency. Returns None if overflow (should disable channel). *)
let calculate_frequency t =
  let delta = t.shadow_frequency lsr t.shift in
  let new_freq =
    if t.negate then begin
      t.negate_used <- true;
      t.shadow_frequency - delta
    end else
      t.shadow_frequency + delta
  in
  if new_freq >= frequency_max then
    None  (* Overflow - channel should be disabled *)
  else
    Some new_freq

(* Clock the sweep. Returns (new_frequency option, should_disable).
   Called at 128 Hz by frame sequencer.
   new_frequency is Some freq if frequency should be updated.
   should_disable is true if overflow occurred. *)
let clock t =
  if not t.enabled then
    (None, false)
  else begin
    t.timer <- t.timer - 1;
    if t.timer <= 0 then begin
      (* Reload timer (period 0 is treated as 8) *)
      t.timer <- if t.period = 0 then 8 else t.period;

      (* Only do sweep calculation if period is non-zero and shift is non-zero *)
      if t.period <> 0 then begin
        match calculate_frequency t with
        | None ->
          (* Overflow - disable channel *)
          (None, true)
        | Some new_freq when t.shift <> 0 ->
          (* Update shadow and check overflow again *)
          t.shadow_frequency <- new_freq;
          begin match calculate_frequency t with
            | None -> (Some new_freq, true)  (* Second overflow check *)
            | Some _ -> (Some new_freq, false)
          end
        | Some _ ->
          (* Shift is 0, no frequency change *)
          (None, false)
      end else
        (None, false)
    end else
      (None, false)
  end

(* Load from NR10 register format *)
let load_from_register t ~register_value =
  t.period <- (register_value lsr 4) land 0x07;
  t.negate <- (register_value land 0x08) <> 0;
  t.shift <- register_value land 0x07

(* Called when channel is triggered.
   Returns true if overflow occurred (channel should be disabled). *)
let trigger t ~frequency =
  t.shadow_frequency <- frequency;
  t.timer <- if t.period = 0 then 8 else t.period;
  t.enabled <- t.period <> 0 || t.shift <> 0;
  t.negate_used <- false;

  (* If shift is non-zero, perform overflow check *)
  if t.shift <> 0 then
    match calculate_frequency t with
    | None -> true   (* Overflow - disable channel *)
    | Some _ -> false
  else
    false

(* Check if switching from negate to non-negate mode after using negate.
   This obscure behavior can disable the channel.
   Returns true if channel should be disabled. *)
let check_negate_to_positive_switch t ~new_negate =
  (* If negate was used and we're switching to positive mode, disable *)
  t.negate_used && t.negate && not new_negate

(* Get the shadow frequency (for updating channel frequency) *)
let get_shadow_frequency t = t.shadow_frequency

(* Update shadow frequency directly (when channel frequency changes) *)
let set_shadow_frequency t freq =
  t.shadow_frequency <- freq

(* Getters for register reads *)
let get_period t = t.period
let get_negate t = t.negate
let get_shift t = t.shift
let is_enabled t = t.enabled

(* Reset the sweep *)
let reset t =
  t.shadow_frequency <- 0;
  t.timer <- 0;
  t.enabled <- false;
  t.period <- 0;
  t.negate <- false;
  t.shift <- 0;
  t.negate_used <- false
