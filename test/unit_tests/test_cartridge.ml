open Camlboy_lib
open Uints
open StdLabels

let%expect_test "load then read" =
  let open Uint16 in
  let rom_bytes = Bytes.init 5 ~f:(fun i -> Char.chr i) in
  let catrdige = Cartridge.create ~rom_bytes ~start_addr:(of_int 0xA1) ~end_addr:(of_int 0xA5) in

  [ Cartridge.read_byte catrdige (of_int 0xA1);
    Cartridge.read_byte catrdige (of_int 0xA2);
    Cartridge.read_byte catrdige (of_int 0xA3);
    Cartridge.read_byte catrdige (of_int 0xA4);
    Cartridge.read_byte catrdige (of_int 0xA5);]
  |> List.map ~f:Uint8.show
  |> List.iter ~f:print_endline;

  [%expect {|
    $00
    $01
    $02
    $03
    $04 |}]
