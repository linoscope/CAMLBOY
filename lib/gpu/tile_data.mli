(** @see <https://gbdev.io/pandocs/Tile_Data.html> *)

open Uints

type t

type set = Set1 | Set2

val create :
  tile_set_ram:Ram.t
  -> set1_start_addr:uint16
  -> set2_start_addr:uint16
  -> t

val get_row_pixels : t -> set:set -> index:int -> row:int -> Color_id.t list

include Addressable_intf.S with type t := t
