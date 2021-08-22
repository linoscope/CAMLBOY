open Uints

module Make (Mmu : Word_addressable_intf.S) : sig

  val f : Mmu.t -> pc:uint16 -> (int * int) * uint16 * Instruction.t

end
