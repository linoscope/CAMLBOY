open Uints

module Make (Bus : Word_addressable_intf.S) : sig

  (** [f bus pc] fetches an instruction from address [pc] of [bus]  *)
  val f : Bus.t -> pc:uint16 -> Inst_info.t

end
