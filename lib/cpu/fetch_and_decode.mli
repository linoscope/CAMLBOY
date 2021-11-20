open Uints

module Make (Mmu : Word_addressable_intf.S) : sig

  type mcycles = {
    not_branched : int;
    branched : int;
  }

  type inst_info = {
    len : uint16;
    mcycles : mcycles;
    inst : Instruction.t;
  }

  val f : Mmu.t -> pc:uint16 -> inst_info

end
