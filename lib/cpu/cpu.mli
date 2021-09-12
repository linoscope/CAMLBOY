open Uints

module Make (Mmu : Word_addressable.S) : sig
  type t [@@deriving show]

  val create : Mmu.t -> Interrupt_controller.t -> t

  (** Returns machine cycle count  *)
  val tick : t -> int

  module For_tests : sig

    val create :
      mmu:Mmu.t ->
      ic:Interrupt_controller.t ->
      registers:Registers.t ->
      sp:uint16 ->
      pc:uint16 ->
      halted:bool ->
      ime:bool ->
      t

    val execute : t -> int * int -> Instruction.t -> int

    val prev_inst : t -> Instruction.t

    val current_pc : t -> uint16

  end
end
