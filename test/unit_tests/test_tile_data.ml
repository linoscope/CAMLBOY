include Camlboy_lib
open Uints

let create () =
  let open Uint16 in
  Tile_data.create
    ~tile_data_ram:(Ram.create ~start_addr:(of_int 0x8000) ~end_addr:(of_int 0x97FF))
    ~area1_start_addr:(of_int 0x8000)
    ~area0_start_addr:(of_int 0x9000)

let%expect_test "test area 1, index 0, row 0" =
  let open Uint16 in
  let t = create () in

  (* (0x8000): [0, 1, 0, 0, 1, 1, 1, 0]
     (0x8001): [1, 0, 0, 0, 1, 0, 1, 1] *)
  t |> Tile_data.write_byte ~addr:(of_int 0x8000) ~data:(Uint8.of_int 0b01001110);
  t |> Tile_data.write_byte ~addr:(of_int 0x8001) ~data:(Uint8.of_int 0b10001011);
  let color_ids = t |> Tile_data.get_row_pixels ~area:Area1 ~index:(Int8.of_int 0) ~row:0 in

  color_ids
  |> Array.map (Color_id.to_int)
  |> Array.iter (print_int);

  [%expect {| 21003132 |}]

let%expect_test "test area 1, index 0, first row" =
  let open Uint16 in
  let t = create () in

  (* (0x9000): [0, 1, 0, 0, 1, 1, 1, 0]
     (0x9001): [1, 0, 0, 0, 1, 0, 1, 1] *)
  t |> Tile_data.write_byte ~addr:(of_int 0x9000) ~data:(Uint8.of_int 0b01001110);
  t |> Tile_data.write_byte ~addr:(of_int 0x9001) ~data:(Uint8.of_int 0b10001011);
  let color_ids = t |> Tile_data.get_row_pixels ~area:Area0 ~index:(Int8.of_int 0) ~row:0 in

  color_ids
  |> Array.map (Color_id.to_int)
  |> Array.iter (print_int);

  [%expect {| 21003132 |}]

let%expect_test "test area 0, index -128, first row" =
  let open Uint16 in
  let t = create () in

  (* (0x8800): [0, 1, 0, 0, 1, 1, 1, 0]
     (0x8801): [1, 0, 0, 0, 1, 0, 1, 1] *)
  t |> Tile_data.write_byte ~addr:(of_int 0x8800) ~data:(Uint8.of_int 0b01001110);
  t |> Tile_data.write_byte ~addr:(of_int 0x8801) ~data:(Uint8.of_int 0b10001011);
  let color_ids = t |> Tile_data.get_row_pixels ~area:Area0 ~index:(Int8.of_int (-128)) ~row:0 in

  color_ids
  |> Array.map (Color_id.to_int)
  |> Array.iter (print_int);

  [%expect {| 21003132 |}]

let%expect_test "test full tile" =
  let open Uint16 in
  let t = create () in

  (* Tile:                                     Image:
   *
   *   .33333..                     .33333.. -> 01111100 -> $7C
   *   22...22.                                 01111100 -> $7C
   *   11...11.                     22...22. -> 00000000 -> $00
   *   2222222. <-- digits                      11000110 -> $C6
   *   33...33.     represent       11...11. -> 11000110 -> $C6
   *   22...22.     color                       00000000 -> $00
   *   11...11.     numbers         2222222. -> 00000000 -> $00
   *   ........                                 11111110 -> $FE
   *                                33...33. -> 11000110 -> $C6
   *   [. = color 0]                            11000110 -> $C6
   *                                22...22. -> 00000000 -> $00
   *                                            11000110 -> $C6
   *                                11...11. -> 11000110 -> $C6
   *                                            00000000 -> $00
   *                                ........ -> 00000000 -> $00
   *                                            00000000 -> $00 *)
  t |> Tile_data.write_byte ~addr:(of_int 0x8010) ~data:(Uint8.of_int 0b01111100);
  t |> Tile_data.write_byte ~addr:(of_int 0x8011) ~data:(Uint8.of_int 0b01111100);
  t |> Tile_data.write_byte ~addr:(of_int 0x8012) ~data:(Uint8.of_int 0b00000000);
  t |> Tile_data.write_byte ~addr:(of_int 0x8013) ~data:(Uint8.of_int 0b11000110);
  t |> Tile_data.write_byte ~addr:(of_int 0x8014) ~data:(Uint8.of_int 0b11000110);
  t |> Tile_data.write_byte ~addr:(of_int 0x8015) ~data:(Uint8.of_int 0b00000000);
  t |> Tile_data.write_byte ~addr:(of_int 0x8016) ~data:(Uint8.of_int 0b00000000);
  t |> Tile_data.write_byte ~addr:(of_int 0x8017) ~data:(Uint8.of_int 0b11111110);
  t |> Tile_data.write_byte ~addr:(of_int 0x8018) ~data:(Uint8.of_int 0b11000110);
  t |> Tile_data.write_byte ~addr:(of_int 0x8019) ~data:(Uint8.of_int 0b11000110);
  t |> Tile_data.write_byte ~addr:(of_int 0x801A) ~data:(Uint8.of_int 0b00000000);
  t |> Tile_data.write_byte ~addr:(of_int 0x801B) ~data:(Uint8.of_int 0b11000110);
  t |> Tile_data.write_byte ~addr:(of_int 0x801C) ~data:(Uint8.of_int 0b11000110);
  t |> Tile_data.write_byte ~addr:(of_int 0x801D) ~data:(Uint8.of_int 0b00000000);
  t |> Tile_data.write_byte ~addr:(of_int 0x801E) ~data:(Uint8.of_int 0b00000000);
  t |> Tile_data.write_byte ~addr:(of_int 0x801F) ~data:(Uint8.of_int 0b00000000);

  Tile_data.print_full_pixels t ~area:Area1 ~index:(Int8.of_int 1);

  [%expect {|
    03333300
    22000220
    11000110
    22222220
    33000330
    22000220
    11000110
    00000000 |}]
