(** Audio Processing Unit (APU) for Game Boy sound emulation.

    The APU handles four sound channels:
    - Square 1: Pulse wave with frequency sweep
    - Square 2: Pulse wave
    - Wave: Custom 32-sample waveform
    - Noise: LFSR-based pseudo-random noise

    Memory-mapped registers: 0xFF10-0xFF26, 0xFF30-0xFF3F (wave RAM) *)

open Uints

type t

(** Create a new APU instance. *)
val create : unit -> t

(** Advance APU state by the given number of M-cycles.
    This updates the frame sequencer and all channels. *)
val run : t -> mcycles:int -> unit

(** Check if the APU handles the given address. *)
val accepts : t -> uint16 -> bool

(** Read a byte from an APU register. *)
val read_byte : t -> uint16 -> uint8

(** Write a byte to an APU register. *)
val write_byte : t -> addr:uint16 -> data:uint8 -> unit
