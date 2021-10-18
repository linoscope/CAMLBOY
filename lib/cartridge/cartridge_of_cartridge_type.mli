(** [f cartridge_type]  returns the module that implements [catridge_type] *)
val f : Cartridge_type.t -> (module Cartridge_intf.S)
