open Uints

module Make (Mmu : Word_addressable_intf.S) : sig
  type t

  val show : t -> string

  val create :
    mmu:Mmu.t ->
    ic:Interrupt_controller.t ->
    registers:Registers.t ->
    sp:uint16 ->
    pc:uint16 ->
    halted:bool ->
    ime:bool ->
    t

  (** Returns machine cycle (mcycle) count  *)
  val run_instruction : t -> int

  module For_tests : sig

    val execute : t -> int * int -> Instruction.t -> int

    val prev_inst : t -> Instruction.t

  end
end
