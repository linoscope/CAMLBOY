open Uints

type t

val create : addr:uint16 -> t

type key =
  | Down
  | Up
  | Left
  | Right
  | Start
  | Select
  | B
  | A

val press : t -> key -> unit

val release : t -> key -> unit

include Addressable_intf.S with type t := t
