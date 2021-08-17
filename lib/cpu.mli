open Ints

type t [@@deriving show]

val create : Memory.t -> t

val tick : t -> unit

(** Module to expose some functions to the test  *)
module For_tests : sig
  val create : memory:Memory.t -> registers:Registers.t -> sp:uint16 -> pc:uint16 -> t
  val execute : t -> uint16 -> Instruction.t -> unit
end
