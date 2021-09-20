(** Utility functiosn for bit manipulation  *)
open Uints

(** 0b11001010 -> true, true, false, false, true, false, true, false  *)
val bitflags_of_byte : uint8 -> bool * bool * bool * bool * bool * bool * bool * bool

val byte_of_bitflags : bool -> bool -> bool -> bool -> bool -> bool -> bool -> bool -> uint8
