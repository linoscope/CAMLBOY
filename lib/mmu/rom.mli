open Uints

type t

val create : start_addr:uint16 -> end_addr:uint16 -> t

val load : t -> rom_bytes:bytes -> unit

include Addressable_intf.S with type t := t
