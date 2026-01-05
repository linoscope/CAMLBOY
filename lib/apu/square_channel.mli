(** Square Wave Channel - Game Boy pulse wave generator.

    Implements the hardware behavior of the Game Boy's square wave channels
    (channels 1 and 2). Produces pulse waves with configurable duty cycle.

    Reference: https://gbdev.gg8.se/wiki/articles/Gameboy_sound_hardware *)

(** Duty cycle patterns. *)
type duty =
  | Duty_12_5  (** 12.5% duty cycle *)
  | Duty_25    (** 25% duty cycle *)
  | Duty_50    (** 50% duty cycle *)
  | Duty_75    (** 75% duty cycle *)

type t

(** {2 Lifecycle} *)

val create : has_sweep:bool -> t
val reset : t -> unit
val trigger : t -> unit

(** {2 Emulation} *)

(** Run channel for given M-cycles, advancing waveform. *)
val run : t -> mcycles:int -> unit

(** Get current sample value (0-15, includes volume). *)
val get_sample : t -> int

(** Clock length counter (called by frame sequencer). *)
val clock_length : t -> unit

(** Clock volume envelope (called by frame sequencer). *)
val clock_envelope : t -> unit

(** {2 Register Access} *)

val set_duty : t -> duty -> unit
val set_frequency : t -> int -> unit
val set_length_enabled : t -> bool -> unit
val set_enabled : t -> bool -> unit
val update_dac : t -> unit

val get_duty : t -> duty
val get_frequency : t -> int
val get_length : t -> Length_counter.t
val get_envelope : t -> Envelope.t
val is_enabled : t -> bool
val has_sweep : t -> bool

(** {2 Duty Conversion} *)

val duty_of_int : int -> duty
val int_of_duty : duty -> int

(** {2 Hardware State for Band-Limited Synthesis}

    These accessors expose raw hardware state needed by {!Blep.HARDWARE}. *)

(** Current position in duty cycle (0-7). *)
val duty_position : t -> int

(** Number of steps in one waveform period (always 8). *)
val duty_steps : int

(** Current frequency timer value (counts down each M-cycle). *)
val frequency_timer : t -> int

(** Timer period in M-cycles for current frequency. *)
val timer_period : t -> int

(** Duty ratio as float (0.125, 0.25, 0.5, or 0.75). *)
val duty_ratio : t -> float

(** Raw waveform output (0 or 1) before volume. *)
val output : t -> int

(** Current envelope volume (0-15). *)
val volume : t -> int

(** Whether channel is actively producing sound. *)
val is_active : t -> bool
