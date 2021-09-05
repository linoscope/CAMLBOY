open Uints

type t

val create : addr:uint16 -> type_:[`R | `W | `RW] -> ?default:uint8 -> unit -> t

val peek : t -> uint8

include Addressable_intf.S with type t := t
