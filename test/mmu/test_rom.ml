open Camlboy_lib
open Uints
open StdLabels

let%expect_test "load then read" =
  let open Uint16 in
  let rom = Rom.create ~start_addr:(of_int 0xA1) ~end_addr:(of_int 0xA5) in
  let rom_bytes = Bytes.init 5 ~f:(fun i -> Char.chr i) in

  Rom.load rom ~rom_bytes;
  [Rom.read_byte rom (of_int 0xA1);
   Rom.read_byte rom (of_int 0xA2);
   Rom.read_byte rom (of_int 0xA3);
   Rom.read_byte rom (of_int 0xA4);
   Rom.read_byte rom (of_int 0xA5);]
  |> List.map ~f:Uint8.show
  |> List.iter ~f:print_endline;

  [%expect {|
    0x00
    0x01
    0x02
    0x03
    0x04 |}]
