open Uints

type t

val create : start_addr:uint16 -> end_addr:uint16 -> t

include Addressable_intf.S with type t := t
