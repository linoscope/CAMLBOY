open Ints

include module type of Instruction_types

val fetch : Memory.t -> pc:uint16 -> t
