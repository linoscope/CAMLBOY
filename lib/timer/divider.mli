(** DIV - Divider Register  *)

open Uints

type t

val create : uint16 -> t

val run : t -> mcycles:int -> unit

include Addressable_intf.S with type t := t
