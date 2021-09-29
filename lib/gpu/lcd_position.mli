(** @see <https://gbdev.io/pandocs/Scrolling.html> *)

open Uints

type t

val create :
  scy_addr:uint16
  -> scx_addr:uint16
  -> ly_addr:uint16
  -> lyc_addr:uint16
  -> wy_addr:uint16
  -> wx_addr:uint16
  -> t

val get_scy : t -> int

val get_scx : t -> int

val get_ly : t -> int

val incr_ly : t -> unit

val reset_ly : t -> unit

val get_lyc : t -> int

val get_wy : t -> int

val get_wx : t -> int


include Addressable_intf.S with type t := t
