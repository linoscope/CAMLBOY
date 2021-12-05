open Camlboy_lib
open Uints

type t

val create : size:int -> t

val load : t -> src:Bigstringaf.t -> dst_pos:uint16 -> unit

val dump : t -> unit

include Word_addressable_intf.S with type t := t
