open Uints

type t

val create : addr:uint16 -> type_:[`R | `W | `RW] -> ?default:uint8 -> unit -> t

include Addressable_intf.S with type t := t
