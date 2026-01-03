(* Volume Envelope - automatically adjusts channel volume over time.

   The envelope is clocked at 64 Hz by the frame sequencer (step 7).
   It can increase or decrease the volume by 1 each period until hitting
   the limits (0 or 15).

   Register format (NRx2 for square/noise channels):
   - Bits 7-4: Initial volume (0-15)
   - Bit 3: Direction (0 = decrease, 1 = increase)
   - Bits 2-0: Period (0-7, 0 means envelope is disabled)

   When period is 0, the envelope doesn't change the volume.
   The timer treats period 0 as 8 for reload purposes.

   Reference: https://gbdev.gg8.se/wiki/articles/Gameboy_sound_hardware#Volume_Envelope *)

type direction = Up | Down

type t = {
  mutable volume : int;      (* Current volume 0-15 *)
  mutable direction : direction;
  mutable period : int;      (* 0-7, 0 means disabled *)
  mutable timer : int;       (* Counts down to next volume change *)
}

let create () = {
  volume = 0;
  direction = Down;
  period = 0;
  timer = 0;
}

(* Clock the envelope. Called at 64 Hz by frame sequencer. *)
let clock t =
  (* Period 0 means envelope is disabled *)
  if t.period = 0 then
    ()
  else begin
    t.timer <- t.timer - 1;
    if t.timer <= 0 then begin
      (* Reload timer (period 0 is treated as 8) *)
      t.timer <- if t.period = 0 then 8 else t.period;
      (* Adjust volume if not at limits *)
      match t.direction with
      | Up when t.volume < 15 ->
        t.volume <- t.volume + 1
      | Down when t.volume > 0 ->
        t.volume <- t.volume - 1
      | Up | Down ->
        ()  (* At limit, no change *)
    end
  end

(* Get current volume for sample generation *)
let get_volume t = t.volume

(* Set volume directly (used by channel trigger and NRx2 writes) *)
let set_volume t volume =
  t.volume <- volume land 0x0F  (* Clamp to 4 bits *)

let get_direction t = t.direction

let set_direction t direction =
  t.direction <- direction

let get_period t = t.period

let set_period t period =
  t.period <- period land 0x07  (* Clamp to 3 bits *)

(* Load from NRx2 register format *)
let load_from_register t ~register_value =
  t.volume <- (register_value lsr 4) land 0x0F;
  t.direction <- if (register_value land 0x08) <> 0 then Up else Down;
  t.period <- register_value land 0x07

(* Called when channel is triggered *)
let trigger t =
  (* Reload timer *)
  t.timer <- if t.period = 0 then 8 else t.period

(* Check if DAC is enabled (volume > 0 or direction is Up) *)
let is_dac_enabled t =
  t.volume <> 0 || t.direction = Up

(* Reset the envelope *)
let reset t =
  t.volume <- 0;
  t.direction <- Down;
  t.period <- 0;
  t.timer <- 0
