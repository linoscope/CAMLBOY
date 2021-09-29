open Uints

type t = {
  addr : uint16;
  (* bit 7 *)
  mutable lcd_enable : bool;
  (* bit 6 *)
  mutable window_tile_map_area : Tile_map.area;
  (* bit 5 *)
  mutable window_enable : bool;
  (* bit 4 *)
  mutable tile_data_area :  Tile_data.area;
  (* bit 3 *)
  mutable bg_tile_map_area : Tile_map.area;
  (* bit 2 *)
  mutable obj_size : bool;
  (* bit 1 *)
  mutable obj_enable : bool;
  (* bit 0 *)
  mutable bg_window_display : bool;
}

let create ~addr = {
  addr;
  lcd_enable = true;
  window_tile_map_area = Tile_map.Area0;
  window_enable = false;
  tile_data_area = Tile_data.Area1;
  bg_tile_map_area = Tile_map.Area0;
  obj_size = false;
  obj_enable = false;
  bg_window_display = true;
}

let get_lcd_enable t = t.lcd_enable

let get_window_tile_map_area t = t.window_tile_map_area

let get_window_enable t = t.window_enable

let get_tile_data_area t = t.tile_data_area

let get_bg_tile_map_area t = t.bg_tile_map_area

let get_obj_size t = t.obj_size

let get_obj_enable t = t.obj_enable

let get_bg_window_display t = t.bg_window_display

let accepts t addr = Uint16.(addr = t.addr)

let read_byte t addr =
  if accepts t addr then begin
    Bit_util.byte_of_bitflags
      t.lcd_enable
      (t.window_tile_map_area = Tile_map.Area1)
      t.window_enable
      (t.tile_data_area = Tile_data.Area1)
      (t.bg_tile_map_area = Tile_map.Area1)
      t.obj_size
      t.obj_enable
      t.bg_window_display
  end else
    raise @@ Invalid_argument "Address out of bounds"

let write_byte' t ~addr ~data =
  if accepts t addr then begin
    let (b7, b6, b5, b4, b3, b2, b1, b0) = Bit_util.bitflags_of_byte data in
    t.lcd_enable <- b7;
    t.window_tile_map_area <- if b6 then Area1 else Area0;
    t.window_enable <- b5;
    t.tile_data_area <- if b4 then Area1 else Area0;
    t.bg_tile_map_area <- if b3 then Area1 else Area0;
    t.obj_size <- b2;
    t.obj_enable <- b1;
    t.bg_window_display <- b0;
    if b7 then
      `Lcd_disabled
    else
      `Nothing
  end else
    raise @@ Invalid_argument "Address out of bounds"

let write_byte t ~addr ~data =
  ignore (write_byte' t ~addr ~data)
