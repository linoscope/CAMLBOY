include Camlboy_lib
open Uints

let create () =
  let open Uint16 in
  Oam_table.create
    ~start_addr:(of_int 0xFE00)
    ~end_addr:(of_int 0xFE9F)

let%expect_test "test write then read" =
  let t = create () in

  let addr0 = Uint16.(of_int 0xFE00 + of_int 2 * of_int 4) in
  let addr1 = Uint16.(addr0 + one) in
  let addr2 = Uint16.(addr0 + of_int 2) in
  let addr3 = Uint16.(addr0 + of_int 3) in
  Oam_table.write_byte t ~addr:addr0 ~data:Uint8.(of_int 0x78);
  Oam_table.write_byte t ~addr:addr1 ~data:Uint8.(of_int 0x4D);
  Oam_table.write_byte t ~addr:addr2 ~data:Uint8.(of_int 0x90);
  Oam_table.write_byte t ~addr:addr3 ~data:Uint8.(of_int 0x30);

  [ Oam_table.read_byte t addr0;
    Oam_table.read_byte t addr1;
    Oam_table.read_byte t addr2;
    Oam_table.read_byte t addr3; ]
  |> List.iter (fun x -> Printf.printf "%s " (Uint8.show x));

  [%expect {| $78 $4D $90 $30 |}]


let%expect_test "test get_all_sprites" =
  let t = create () in

  let offset = Uint16.(of_int 0xFE00 + of_int 2 * of_int 4) in
  Oam_table.write_byte t ~addr:offset ~data:Uint8.(of_int 0x78);
  Oam_table.write_byte t ~addr:Uint16.(offset + one) ~data:Uint8.(of_int 0x4D);
  Oam_table.write_byte t ~addr:Uint16.(offset + of_int 2) ~data:Uint8.(of_int 0x90);
  Oam_table.write_byte t ~addr:Uint16.(offset + of_int 3) ~data:Uint8.(of_int 0x30);

  Oam_table.get_all_sprites t
  |> (fun a -> Array.get a 2)
  |> Oam_table.show_sprite
  |> print_endline;

  [%expect {|
    { Oam_table.y_pos = 104; x_pos = 69; tile_index = $90;
      priority = `Sprite_top; y_flip = false; x_flip = true; pallete = `OBP1;
      tile_vram_bank = `Bank0; pallete_num = 0 } |}]
