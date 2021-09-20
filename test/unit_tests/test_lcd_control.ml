include Camlboy_lib
open Uints

let addr = (Uint16.of_int 0xFF04)

let%expect_test "test" =
  let t = Lcd_control.create ~addr in
  Lcd_control.write_byte t ~addr ~data:(Uint8.of_int 0x91);

  Lcd_control.read_byte t addr
  |> Uint8.show
  |> print_endline;

  [%expect {| $91 |}];

  let print_tile_map_area a = (a = Tile_map.Area1) |> Printf.printf "%b\n" in
  let print_tile_data_area a = (a = Tile_data.Area1) |> Printf.printf "%b\n" in
  let print_bool = Printf.printf "%b\n" in
  Lcd_control.get_lcd_enable t |> print_bool;
  Lcd_control.get_window_tile_map_area t |> print_tile_map_area;
  Lcd_control.get_window_enable t |> print_bool;
  Lcd_control.get_tile_data_area t |> print_tile_data_area;
  Lcd_control.get_bg_tile_map_area t |> print_tile_map_area;
  Lcd_control.get_obj_size t |> print_bool;
  Lcd_control.get_obj_enable t |> print_bool;
  Lcd_control.get_bg_window_display t |> print_bool;

  [%expect {|
    true
    false
    false
    true
    false
    false
    false
    true |}];
