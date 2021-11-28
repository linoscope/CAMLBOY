open Uints

module Make (Bus : Word_addressable_intf.S) : sig
  type t

  val create :
    bus:Bus.t ->
    ic:Interrupt_controller.t ->
    registers:Registers.t ->
    sp:uint16 ->
    pc:uint16 ->
    halted:bool ->
    ime:bool ->
    t

  (** Executes a single instruction. Returns machine cycle (mcycle) count consumed during the execution. *)
  val run_instruction : t -> int

  val show : t -> string

  module For_tests : sig

    val execute :
      t ->
      branched_mcycles:int ->
      not_branched_mcycles:int ->
      inst:Instruction.t ->
      int

    val prev_inst : t -> Instruction.t

  end
end
