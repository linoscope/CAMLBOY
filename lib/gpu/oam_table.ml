open Uints

type sprite = {
  y_pos : int;
  x_pos : int;
  tile_index : uint8;
  priority : [`Sprite_top | `Sprite_bottom];
  y_flip : bool;
  x_flip : bool;
  pallete : [`OBP0 | `OBP1];
  tile_vram_bank : [`Bank0 | `Bank1];
  pallete_num : int;
} [@@deriving show]

type t = {
  sprites : sprite array;
  start_addr : uint16;
  end_addr : uint16;
}

let create ~start_addr ~end_addr =
  let default_sprite = {
    y_pos = 0;
    x_pos = 0;
    tile_index = Uint8.zero;
    priority = `Sprite_top;
    y_flip = false;
    x_flip = false;
    pallete = `OBP0;
    tile_vram_bank = `Bank0;
    pallete_num = 0; }
  in
  let sprites = Array.make 40 default_sprite in
  { sprites;
    start_addr;
    end_addr; }

let read_byte t addr =
  let offset = Uint16.to_int addr - (Uint16.to_int t.start_addr) in
  let sprite = t.sprites.(offset / 4) in
  match offset mod 4 with
  | 0 -> sprite.y_pos + 16 |> Uint8.of_int
  | 1 -> sprite.x_pos +  8 |> Uint8.of_int
  | 2 -> sprite.tile_index
  | 3 ->
    Bit_util.byte_of_bitflags
      (sprite.priority = `Sprite_bottom)
      sprite.y_flip
      sprite.x_flip
      (sprite.pallete = `OBP1)
      (sprite.tile_vram_bank = `Bank1)
      (sprite.pallete_num land 0b100 <> 0)
      (sprite.pallete_num land 0b010 <> 0)
      (sprite.pallete_num land 0b001 <> 0)
  | _ -> assert false

let write_byte t ~addr ~data =
  let offset = Uint16.to_int addr - (Uint16.to_int t.start_addr) in
  let data' = Uint8.to_int data in
  let sprite_index = offset / 4 in
  match offset mod 4 with
  | 0 ->
    t.sprites.(sprite_index) <- {t.sprites.(sprite_index) with y_pos = (data' - 16)}
  | 1 ->
    t.sprites.(sprite_index) <- {t.sprites.(sprite_index) with x_pos = (data' - 8)}
  | 2 ->
    t.sprites.(sprite_index) <- {t.sprites.(sprite_index) with tile_index = data}
  | 3 ->
    let (b7, y_flip, x_flip, b4, b3, b2, b1, b0) = data |> Bit_util.bitflags_of_byte in
    let priority = if b7 then `Sprite_bottom else `Sprite_top in
    let pallete = if b4 then `OBP1 else `OBP0 in
    let tile_vram_bank = if b3 then `Bank1 else `Bank0 in
    let pallete_num = (Bool.to_int b2 lsl 2) lor (Bool.to_int b1 lsl 1) lor (Bool.to_int b0) in
    t.sprites.(sprite_index) <-
      { t.sprites.(sprite_index) with
        y_flip; x_flip; priority; pallete; tile_vram_bank; pallete_num; }
  | _ -> assert false

let accepts t addr = Uint16.(t.start_addr <= addr && addr <= t.end_addr)

let get_all_sprites t = t.sprites

let write_with_offset t ~offset ~data =
  write_byte t ~addr:Uint16.(t.start_addr + of_int offset) ~data
