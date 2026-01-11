(** Band-Limited Step (BLEP) synthesis for anti-aliased audio.

    This module provides a functor that wraps hardware square wave
    emulation with polyBLEP anti-aliasing correction.

    The base hardware module implements exact Game Boy behavior.
    This wrapper adds the corrections needed because we're outputting
    to a sampled audio format rather than analog hardware.

    Reference: https://www.martin-finke.de/articles/audio-plugins-018-polyblep-oscillator/ *)

(** {2 Hardware Interface}

    Signature for the underlying hardware emulation.
    Only exposes concepts that exist in the actual Game Boy hardware. *)
module type HARDWARE = sig
  type t

  (** Current position in duty cycle (0 to duty_steps-1). *)
  val duty_position : t -> int

  (** Number of steps in one waveform period. (8 for Game Boy square) *)
  val duty_steps : int

  (** Current frequency timer value (counts down each M-cycle). *)
  val frequency_timer : t -> int

  (** Timer period in M-cycles (time per duty step). *)
  val timer_period : t -> int

  (** Duty ratio: fraction of period where output is high.
      E.g., 0.5 for 50% duty cycle. *)
  val duty_ratio : t -> float

  (** Raw waveform output before volume (0 or 1). *)
  val output : t -> int

  (** Current envelope volume (0-15). *)
  val volume : t -> int

  (** Whether channel is enabled and DAC is on. *)
  val is_active : t -> bool
end

(** {2 Band-Limited Wrapper} *)

(** Functor that adds band-limited output to a hardware square wave. *)
module Make (H : HARDWARE) : sig
  (** Get band-limited sample value.

      Computes continuous phase from hardware state and applies
      polyBLEP correction to eliminate aliasing.

      @param hw The hardware channel state
      @param sample_rate Output sample rate in Hz
      @return Sample value in range [-1.0, 1.0] (before volume),
              or 0.0 if channel is inactive *)
  val get_sample : H.t -> sample_rate:int -> float

  (** Get the computed continuous phase (for testing/visualization).
      @return Phase in range [0.0, 1.0) *)
  val get_phase : H.t -> float

  (** Get normalized frequency dt (for testing/visualization).
      @return Phase increment per output sample *)
  val get_dt : H.t -> sample_rate:int -> float
end

(** {2 Pure Functions}

    Exposed for testing and visualization. *)

(** The polyBLEP correction polynomial.

    Smooths a discontinuity at t=0 over approximately one sample.

    @param t Phase relative to discontinuity, in [0.0, 1.0)
    @param dt Normalized frequency (freq_hz / sample_rate)
    @return Correction to add (rising edge) or subtract (falling edge) *)
val poly_blep : t:float -> dt:float -> float

(** Pure band-limited square wave function.

    @param phase Current phase in [0.0, 1.0)
    @param dt Normalized frequency
    @param duty Duty cycle ratio in [0.0, 1.0]
    @return Sample in range [-1.0, 1.0] *)
val square : phase:float -> dt:float -> duty:float -> float
