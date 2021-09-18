(** DIV - Divider Register  *)

open Uints

type t

val create : uint16 -> t

include Runnable_intf.S with type t := t

include Addressable_intf.S with type t := t
