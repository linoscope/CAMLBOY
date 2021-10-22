open Camlboy_lib
open Uints
open StdLabels

let create () =
  let rom_bytes = Bytes.init 0x16000 ~f:(fun i -> Char.chr ((i lsr 8) land 0xFF)) in
  Cartridge_mbc1.create ~rom_bytes

let%expect_test "test rom bank switch" =
  let open Uint16 in
  let t = create () in

  [0x0000; 0x3FFF; 0x4000; 0x7FFF]
  |> List.map ~f:of_int
  |> List.iter ~f:(fun addr ->
      Cartridge_mbc1.read_byte t addr
      |> Uint8.show
      |> print_endline);

  [%expect {|
    $00
    $3F
    $40
    $7F |}];

  (* Bank switch *)
  Cartridge_mbc1.write_byte t ~addr:(of_int 0x2000) ~data:(Uint8.of_int 2);

  [0x0000; 0x3FFF; 0x4000; 0x7FFF]
  |> List.map ~f:of_int
  |> List.iter ~f:(fun addr ->
      Cartridge_mbc1.read_byte t addr
      |> Uint8.show
      |> print_endline);

  [%expect {|
    $00
    $3F
    $80
    $BF |}];

  (* Bank switch *)
  Cartridge_mbc1.write_byte t ~addr:(of_int 0x2000) ~data:(Uint8.of_int 3);

  [0x0000; 0x3FFF; 0x4000; 0x7FFF]
  |> List.map ~f:of_int
  |> List.iter ~f:(fun addr ->
      Cartridge_mbc1.read_byte t addr
      |> Uint8.show
      |> print_endline);

  [%expect {|
    $00
    $3F
    $C0
    $FF |}];

  (* Bank switch *)
  Cartridge_mbc1.write_byte t ~addr:(of_int 0x2000) ~data:(Uint8.of_int 1);

  [0x0000; 0x3FFF; 0x4000; 0x7FFF]
  |> List.map ~f:of_int
  |> List.iter ~f:(fun addr ->
      Cartridge_mbc1.read_byte t addr
      |> Uint8.show
      |> print_endline);

  [%expect {|
    $00
    $3F
    $40
    $7F |}]
