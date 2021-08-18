open Ints

include module type of Instruction_types

(* Returns (length_of_instruction, instruction) pair *)
val fetch_and_decode : Memory.t -> pc:uint16 -> uint16 * t
