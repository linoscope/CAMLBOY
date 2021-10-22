open Camlboy_lib
open Uints
open StdLabels

let%expect_test "load then read" =
  let open Uint16 in
  let rom_bytes = Bytes.init 5 ~f:(fun i -> Char.chr i) in
  let catrdige = Cartridge_rom_only.create ~rom_bytes in

  [ Cartridge_rom_only.read_byte catrdige (of_int 0x00);
    Cartridge_rom_only.read_byte catrdige (of_int 0x01);
    Cartridge_rom_only.read_byte catrdige (of_int 0x02);
    Cartridge_rom_only.read_byte catrdige (of_int 0x03);
    Cartridge_rom_only.read_byte catrdige (of_int 0x04);]
  |> List.map ~f:Uint8.show
  |> List.iter ~f:print_endline;

  [%expect {|
    $00
    $01
    $02
    $03
    $04 |}]
