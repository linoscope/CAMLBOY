(** LCD Control Register. @see <https://gbdev.io/pandocs/LCDC.html>  *)

open Uints

type t

val create : addr:uint16 -> t

val get_lcd_enable : t -> bool

val get_window_tile_map_area : t -> Tile_map.area

val get_window_enable : t -> bool

val get_tile_data_area : t -> Tile_data.area

val get_bg_tile_map_area : t -> Tile_map.area

val get_obj_size : t -> bool    (* TODO: Replace bool with more descriptive type *)

val get_obj_enable : t -> bool

val get_bg_window_display : t -> bool

include Addressable_intf.S with type t := t
