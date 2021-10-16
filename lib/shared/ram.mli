open Uints

type t

val create : start_addr:uint16 -> end_addr:uint16 -> t

val write_with_offset : t -> offset:int -> data:uint8 -> unit

include Addressable_intf.S with type t := t

