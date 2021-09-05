open Uints

module Make (Mmu : Word_addressable.S) : sig
  type t [@@deriving show]

  val create : Mmu.t -> t

  (** Returns machine cycle count  *)
  val tick : t -> int

  val prev_inst : t -> Instruction.t

  module For_tests : sig
    val create :
      mmu:Mmu.t ->
      registers:Registers.t ->
      sp:uint16 ->
      pc:uint16 ->
      halted:bool ->
      ime:bool ->
      t
    val execute : t -> int * int -> Instruction.t -> int
  end
end
