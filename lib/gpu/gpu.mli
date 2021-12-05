open Uints

type t

val create :
  tile_data:Tile_data.t ->
  tile_map:Tile_map.t ->
  oam:Oam_table.t ->
  bgp:Pallete.t ->
  obp0:Pallete.t ->
  obp1:Pallete.t ->
  lcd_stat:Lcd_stat.t ->
  lcd_control:Lcd_control.t ->
  lcd_position:Lcd_position.t ->
  ic:Interrupt_controller.t ->
  t

val get_frame_buffer : t -> [`White | `Light_gray | `Dark_gray | `Black ] array array

(** Used for DMA transfer.  *)
val write_oam_with_offset : t -> offset:int -> data:uint8 -> unit

type run_result =
  | In_frame
  | Frame_ended of [`White | `Light_gray | `Dark_gray | `Black ] array array

val run : t -> mcycles:int -> run_result

include Addressable_intf.S with type t := t

module For_tests : sig

  (** Same as Runnable_intf.S.run but returns information about mode change  *)
  val run : t -> mcycles:int -> [`Mode_changed | `Mode_not_changed]

  val show : t -> string

  val get_mcycles_in_mode : t -> int

end
