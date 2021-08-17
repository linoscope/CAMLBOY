open Ints

type t [@@deriving show]

val create : Memory.t -> t

val tick : t -> unit

(**/**)
(* The following functions are exposed for testing purpose *)

val execute : t -> uint16 -> Instruction.t -> unit

val create_for_testing : memory:Memory.t -> registers:Registers.t -> sp:uint16 -> pc:uint16 -> t
