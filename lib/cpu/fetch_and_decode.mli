open Uints

module Make (Mmu : Word_addressable.S) : sig

  (** Returns (instruction length, (mcycle when not branched, mcycle when branched), instruction) *)
  val f : Mmu.t -> pc:uint16 -> uint16 * (int * int) * Instruction.t

end
