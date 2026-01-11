(* Band-Limited Step (BLEP) synthesis for anti-aliased audio.

   polyBLEP uses polynomial approximations to smooth discontinuities
   in square waves, preventing aliasing when sampling to digital audio.

   The Game Boy runs at 1048576 M-cycles/second. A square wave with
   frequency register F has period (2048-F) M-cycles per duty step,
   and 8 duty steps per waveform period.

   When we sample at e.g. 44100 Hz, frequencies with harmonics above
   22050 Hz would alias. polyBLEP corrects transitions to be
   band-limited, eliminating this aliasing. *)

let mcycles_per_second = float Constants.mcycles_per_second

module type HARDWARE = sig
  type t
  val duty_position : t -> int
  val duty_steps : int
  val frequency_timer : t -> int
  val timer_period : t -> int
  val duty_ratio : t -> float
  val output : t -> int
  val volume : t -> int
  val is_active : t -> bool
end

(* polyBLEP correction polynomial.

   For a discontinuity at t=0:
   - When t is in [0, dt): we just passed the edge, blend down
   - When t is in [1-dt, 1): we're about to hit the edge, blend up

   The polynomial provides a smooth transition over ~1 sample. *)
let poly_blep ~t ~dt =
  if dt <= 0.0 then
    0.0
  else if t < dt then
    (* Just passed discontinuity: t/dt goes from 0 to 1 *)
    let t_norm = t /. dt in
    (* Polynomial: 2t - t² - 1, ranges from -1 to 0 *)
    t_norm +. t_norm -. t_norm *. t_norm -. 1.0
  else if t > 1.0 -. dt then
    (* Approaching discontinuity: (t-1)/dt goes from -1 to 0 *)
    let t_norm = (t -. 1.0) /. dt in
    (* Polynomial: t² + 2t + 1, ranges from 0 to 1 *)
    t_norm *. t_norm +. t_norm +. t_norm +. 1.0
  else
    0.0

(* Pure band-limited square wave.

   phase: current position in waveform [0, 1)
   dt: normalized frequency (how much phase advances per sample)
   duty: duty cycle ratio [0, 1] (e.g., 0.5 = 50%) *)
let square ~phase ~dt ~duty =
  (* Naive square: high when phase < duty, low otherwise *)
  let naive = if phase < duty then 1.0 else -1.0 in

  (* Apply BLEP correction at rising edge (phase = 0) *)
  let correction = poly_blep ~t:phase ~dt in

  (* Apply BLEP correction at falling edge (phase = duty) *)
  let t_fall = phase -. duty in
  let t_fall = if t_fall < 0.0 then t_fall +. 1.0 else t_fall in
  let correction = correction -. poly_blep ~t:t_fall ~dt in

  naive +. correction

module Make (H : HARDWARE) = struct
  (* Compute continuous phase [0, 1) from hardware state.

     The hardware has:
     - duty_position: which of the 8 steps we're in (0-7)
     - frequency_timer: countdown within current step
     - timer_period: total cycles per step

     Phase within current step:
       step_phase = (period - timer) / period = 1 - timer/period

     Total phase:
       phase = (duty_position + step_phase) / duty_steps *)
  let get_phase hw =
    let period = float_of_int (H.timer_period hw) in
    let timer = float_of_int (H.frequency_timer hw) in
    let step_phase =
      if period > 0.0 then 1.0 -. (timer /. period) else 0.0
    in
    let pos = float_of_int (H.duty_position hw) in
    let steps = float_of_int H.duty_steps in
    (pos +. step_phase) /. steps

  (* Compute normalized frequency (phase increment per sample).

     Waveform frequency in Hz:
       freq = mcycles_per_second / (timer_period * duty_steps)

     Normalized frequency:
       dt = freq / sample_rate *)
  let get_dt hw ~sample_rate =
    let period = float_of_int (H.timer_period hw) in
    let steps = float_of_int H.duty_steps in
    if period <= 0.0 then
      0.0
    else
      let freq_hz = mcycles_per_second /. (period *. steps) in
      freq_hz /. float_of_int sample_rate

  (* Get band-limited sample. *)
  let get_sample hw ~sample_rate =
    if not (H.is_active hw) then
      0.0
    else
      let phase = get_phase hw in
      let dt = get_dt hw ~sample_rate in
      let duty = H.duty_ratio hw in
      let wave = square ~phase ~dt ~duty in
      (* Scale by volume (0-15 -> 0.0-1.0) and preserve sign *)
      let vol = float_of_int (H.volume hw) /. 15.0 in
      wave *. vol
end
