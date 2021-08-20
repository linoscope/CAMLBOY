open Uints

module Make (Mmu : Addressable_intf.S) : sig
  type t [@@deriving show]

  val create : Mmu.t -> t

  val tick : t -> unit

  (** Module to expose some functions to the test  *)
  module For_tests : sig
    val create :
      mmu:Mmu.t ->
      registers:Registers.t ->
      sp:uint16 ->
      pc:uint16 ->
      halted:bool ->
      ime:bool ->
      t
    val execute : t -> uint16 -> Instruction.t -> unit
  end
end
