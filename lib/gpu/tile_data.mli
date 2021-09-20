(** @see <https://gbdev.io/pandocs/Tile_Data.html> *)
open Uints

type t

type area = Area0 | Area1

val create :
  tile_data_ram:Ram.t
  -> area0_start_addr:uint16
  -> area1_start_addr:uint16
  -> t

val get_row_pixels : t -> area:area -> index:int -> row:int -> Color_id.t list

include Addressable_intf.S with type t := t
