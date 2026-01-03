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

   Note: There's a subtle edge case on real hardware where if length is enabled
   and we're on a frame sequencer step that clocks length, an extra clock happens.
   This will be handled by the channel implementation when needed. *)
let trigger t =
  if t.counter = 0 then
    t.counter <- t.max_length

(* Reset the length counter *)
let reset t =
  t.counter <- 0;
  t.enabled <- false
