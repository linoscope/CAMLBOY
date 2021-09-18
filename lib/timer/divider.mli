(** DIV - Divider Register  *)

open Uints

type t

val run : t -> cycles:int -> unit

val create : uint16 -> t

include Addressable_intf.S with type t := t
