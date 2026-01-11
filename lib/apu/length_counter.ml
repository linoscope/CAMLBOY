(* Length Counter - can automatically disable a channel after a set time.

   The length counter is clocked at 256 Hz by the frame sequencer (steps 0, 2, 4, 6).
   When enabled, it decrements each clock. When it reaches 0, the channel is disabled.

   Different channels have different maximum lengths:
   - Square 1, Square 2, Noise: 64 (6-bit counter, loaded as 64 - value)
   - Wave: 256 (8-bit counter, loaded as 256 - value)

   Reference: https://gbdev.gg8.se/wiki/articles/Gameboy_sound_hardware#Length_Counter *)

type t = {
  mutable counter : int;     (* Current length value *)
  mutable enabled : bool;    (* Whether length is active *)
  max_length : int;          (* 64 for square/noise, 256 for wave *)
}

let create ~max_length = {
  counter = 0;
  enabled = false;
  max_length;
}

(* Clock the length counter. Returns true if the channel should be disabled. *)
let clock t =
  if t.enabled && t.counter > 0 then begin
    t.counter <- t.counter - 1;
    t.counter = 0  (* Return true if we just hit zero *)
  end else
    false

(* Set the length value. On hardware this is written as (max - value). *)
let set_length t value =
  t.counter <- value

(* Load length from register value (register contains max - length). *)
let load_from_register t ~register_value =
  t.counter <- t.max_length - register_value

(* Enable or disable the length counter *)
let set_enabled t enabled =
  t.enabled <- enabled

let is_enabled t = t.enabled

(* Get current counter value *)
let get_counter t = t.counter

(* Get max length *)
let get_max_length t = t.max_length

(* Called when channel is triggered.
   If counter is 0, it's reloaded with max_length.

   Obscure behavior: If triggered when the frame sequencer's next step doesn't
   clock length, AND length is now enabled, AND length was being set to max
   because it was 0, then set it to max-1 instead.
   Reference: https://gbdev.gg8.se/wiki/articles/Gameboy_sound_hardware#Trigger_Event *)
let trigger t ~next_step_clocks_length =
  if t.counter = 0 then begin
    t.counter <- t.max_length;
    (* Obscure: if next step doesn't clock length and length is enabled,
       use max-1 instead of max *)
    if t.enabled && not next_step_clocks_length then
      t.counter <- t.counter - 1
  end

(* Extra clocking on NRx4 write.
   Obscure behavior: When writing to NRx4 and the next frame sequencer step
   won't clock length, if length was previously disabled and is now being
   enabled and counter is non-zero, decrement the counter.
   Returns true if the channel should be disabled (counter reached 0).
   Reference: https://gbdev.gg8.se/wiki/articles/Gameboy_sound_hardware#Length_Counter *)
let extra_clock_on_enable t ~was_enabled ~next_step_clocks_length =
  if not was_enabled && t.enabled && not next_step_clocks_length && t.counter > 0 then begin
    t.counter <- t.counter - 1;
    t.counter = 0  (* Return true if we hit zero *)
  end else
    false

(* Reset the length counter *)
let reset t =
  t.counter <- 0;
  t.enabled <- false
