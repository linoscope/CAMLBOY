open Uints

module Make (Mmu : Word_addressable_intf.S) : sig
  type t [@@deriving show]

  val create : Mmu.t -> t

  (** Returns machine cycle count  *)
  val tick : t -> int

  module For_tests : sig
    val create :
      mmu:Mmu.t ->
      registers:Registers.t ->
      sp:uint16 ->
      pc:uint16 ->
      halted:bool ->
      ime:bool ->
      t
    val execute : t -> uint16 -> int * int -> _ Instruction.t -> int
  end
end
