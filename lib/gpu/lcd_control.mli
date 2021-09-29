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

(** Returns `Lcd_disabled when the write disables the lcd (i.e. sets bit 7 from 0 to 1)*)
val write_byte' : t -> addr:uint16 -> data:uint8 -> [`Lcd_disabled | `Nothing]

include Addressable_intf.S with type t := t
