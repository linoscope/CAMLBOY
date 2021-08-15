open Ints

type t

type r =
  | A
  | B
  | C
  | D
  | E
  | F
  | H
  | L

type rr =
  | AF
  | BC
  | DE
  | HL

type flag =
  | Carry
  | Half_carry
  | Subtraction
  | Zero

val read_r : t -> r -> uint8

val write_r : t -> r -> uint8 -> unit

val read_rr : t -> rr -> uint16

val write_rr : t -> rr -> uint16 -> unit

val read_flag : t -> flag -> bool

val set_flag : t -> flag -> unit

val unset_flag : t -> flag -> unit
