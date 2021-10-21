open Camlboy_lib
open Uints

let%expect_test "test initial value" =
  let addr = (Uint16.of_int 0xFF00) in
  let t = Joypad.create ~addr in

  Joypad.read_byte t addr
  |> Uint8.show
  |> print_endline;

  [%expect {| $DF |}]
