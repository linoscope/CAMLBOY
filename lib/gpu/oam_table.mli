open Uints

type t

type sprite = {
  y_pos : int;
  x_pos : int;
  tile_index : uint8;
  priority : [`Sprite_top | `Sprite_bottom];
  y_flip : bool;
  x_flip : bool;
  pallete : [`OBP0 | `OBP1];
} [@@deriving show]

val create : start_addr:uint16 -> end_addr:uint16 -> oam_ram:Ram.t -> t

val get_all_sprites : t -> sprite list

val write_with_offset : t -> offset:int -> data:uint8 -> unit

include Addressable_intf.S with type t := t
