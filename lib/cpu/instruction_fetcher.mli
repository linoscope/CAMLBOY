open Uints

module Make (Mmu : Addressable_intf.S) : sig
  (* Returns (length_of_instruction, instruction) pair *)
  val fetch_and_decode : Mmu.t -> pc:uint16 -> uint16 * Instruction.t
end
