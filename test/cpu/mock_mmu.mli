open Camlboy_lib
open Uints

type t

val create : size:int -> t

val load : t -> src:bytes -> dst_pos:uint16 -> unit

include Addressable_intf.S with type t := t
