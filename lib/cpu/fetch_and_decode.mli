open Uints

module Make (Bus : Word_addressable_intf.S) : sig

  type mcycles = {
    not_branched : int;
    branched : int;
  }

  type inst_info = {
    len : uint16;
    mcycles : mcycles;
    inst : Instruction.t;
  }

  (** [f bus pc] fetches an instruction from address [pc] of [bus]  *)
  val f : Bus.t -> pc:uint16 -> inst_info

end
