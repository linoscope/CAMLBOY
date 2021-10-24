(** [f ~rom_bytes] detects the cartridge type and returns the module that implements
 **  the detected given catridge type *)
val f : rom_bytes:Bigstringaf.t -> (module Cartridge_intf.S)
