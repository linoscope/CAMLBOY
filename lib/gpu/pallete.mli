(** Manages mapping from color id (00, 01..) to colors (White, Black,..)
 ** @see <https://gbdev.io/pandocs/Palettes.html> *)

open Uints

type t

val create : addr:uint16 -> t

val lookup : t -> Color_id.t -> Color.t

include Addressable_intf.S with type t := t
