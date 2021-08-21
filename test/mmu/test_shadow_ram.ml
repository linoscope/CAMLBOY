open Camlboy_lib
open Uints
open StdLabels

let%expect_test "test" =
  let target_start = Uint16.of_int 0xC000 in
  let target_end   = Uint16.of_int 0xDFFF in
  let shadow_start = Uint16.of_int 0xE000 in
  let shadow_end   = Uint16.of_int 0xFDFF in
  let target =
    Ram.create ~start_addr:target_start ~end_addr:target_end
  in
  let shadow_ram =
    Shadow_ram.create ~target:target ~target_start ~shadow_start ~shadow_end
  in

  Ram.write_byte target ~addr:(Uint16.of_int 0xC000) ~data:(Uint8.of_int 0xAA);
  Ram.write_byte target ~addr:(Uint16.of_int 0xDBBB) ~data:(Uint8.of_int 0xBB);
  Ram.write_byte target ~addr:(Uint16.of_int 0xDDFF) ~data:(Uint8.of_int 0xCC);

  [
    Shadow_ram.read_byte shadow_ram (Uint16.of_int 0xE000);
    Shadow_ram.read_byte shadow_ram (Uint16.of_int 0xFBBB);
    Shadow_ram.read_byte shadow_ram (Uint16.of_int 0xFDFF);
  ]
  |> List.map ~f:Uint8.show
  |> List.iter ~f:print_endline;

  [%expect {|
    0xaa
    0xbb
    0xcc |}]
