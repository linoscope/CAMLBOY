open Camlboy_lib
open Uints
open StdLabels

let%expect_test "load then read" =
  let open Uint16 in
  let rom_bytes = Bytes.init 5 ~f:(fun i -> Char.chr i) in
  let catrdige = Rom_only.create ~rom_bytes ~start_addr:(of_int 0xA1) ~end_addr:(of_int 0xA5) in

  [ Rom_only.read_byte catrdige (of_int 0xA1);
    Rom_only.read_byte catrdige (of_int 0xA2);
    Rom_only.read_byte catrdige (of_int 0xA3);
    Rom_only.read_byte catrdige (of_int 0xA4);
    Rom_only.read_byte catrdige (of_int 0xA5);]
  |> List.map ~f:Uint8.show
  |> List.iter ~f:print_endline;

  [%expect {|
    $00
    $01
    $02
    $03
    $04 |}]
