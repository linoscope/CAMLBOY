(** @see <https://gbdev.io/pandocs/Tile_Data.html> *)
open Uints

type t

type area = Area1 | Area0

val create :
  tile_data_ram:Ram.t ->
  area1_start_addr:uint16 ->
  area0_start_addr:uint16 ->
  t

val get_pixel : t -> area:area -> index:uint8 -> row:int -> col:int -> Color_id.t

val get_row_pixels : t -> area:area -> index:uint8 -> row:int -> Color_id.t array

val get_full_pixels : t -> area:area -> index:uint8 -> Color_id.t array array

val print_full_pixels : t -> area:area -> index:uint8 -> unit

include Addressable_intf.S with type t := t
