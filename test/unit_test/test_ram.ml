open Camlboy_lib
open Uints
open StdLabels

let%expect_test "write then read" =
  let ram = Ram.create ~start_addr:(Uint16.of_int 0xAA) ~end_addr:(Uint16.of_int 0xCC) in

  Ram.write_byte ram ~addr:(Uint16.of_int 0xAA) ~data:(Uint8.of_int 0x11);
  Ram.write_byte ram ~addr:(Uint16.of_int 0xBB) ~data:(Uint8.of_int 0x22);
  Ram.write_byte ram ~addr:(Uint16.of_int 0xCC) ~data:(Uint8.of_int 0x33);
  [
    Ram.read_byte ram (Uint16.of_int 0xAA);
    Ram.read_byte ram (Uint16.of_int 0xBB);
    Ram.read_byte ram (Uint16.of_int 0xCC);
  ]
  |> List.map ~f:Uint8.show
  |> List.iter ~f:print_endline;

  [%expect {|
    $11
    $22
    $33 |}]
