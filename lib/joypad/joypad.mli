open Uints

type t

val create : addr:uint16 -> t

include Addressable_intf.S with type t := t
