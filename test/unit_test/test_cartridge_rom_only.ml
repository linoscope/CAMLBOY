open Camlboy_lib
open Uints
open StdLabels

let%expect_test "load then read" =
  let open Uint16 in
  let rom_string = String.init 5 ~f:(fun i -> Char.chr i) in
  let len = String.length rom_string in
  let rom_bytes = Bigstringaf.of_string ~off:0 ~len rom_string in
  let catrdige = Rom_only.create ~rom_bytes in


  [ Rom_only.read_byte catrdige (of_int 0x00);
    Rom_only.read_byte catrdige (of_int 0x01);
    Rom_only.read_byte catrdige (of_int 0x02);
    Rom_only.read_byte catrdige (of_int 0x03);
    Rom_only.read_byte catrdige (of_int 0x04);]
  |> List.map ~f:Uint8.show
  |> List.iter ~f:print_endline;

  [%expect {|
    $00
    $01
    $02
    $03
    $04 |}]
