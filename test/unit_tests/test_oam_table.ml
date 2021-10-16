include Camlboy_lib
open Uints

let create () =
  let open Uint16 in
  Oam_table.create
    ~start_addr:(of_int 0xFE00)
    ~oam_ram:(Ram.create ~start_addr:(of_int 0xFE00) ~end_addr:(of_int 0xFE9F))

let%expect_test "test" =
  let t = create () in

  let offset = Uint16.(of_int 0xFE00 + of_int 2 * of_int 4) in
  Oam_table.write_byte t ~addr:offset ~data:Uint8.(of_int 0x78);
  Oam_table.write_byte t ~addr:Uint16.(offset + one) ~data:Uint8.(of_int 0x4D);
  Oam_table.write_byte t ~addr:Uint16.(offset + of_int 2) ~data:Uint8.(of_int 0x90);
  Oam_table.write_byte t ~addr:Uint16.(offset + of_int 3) ~data:Uint8.(of_int 0x30);

  Oam_table.get_sprite_info t ~index:2
  |> Oam_table.show_sprite_info
  |> print_endline;

  [%expect {|
    { Oam_table.y_pos = 104; x_pos = 69; tile_index = 144;
      priority = `Sprite_bottom; y_flip = false; x_flip = true; pallete = `OBP1 } |}]
