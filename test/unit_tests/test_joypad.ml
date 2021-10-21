open Camlboy_lib
open Uints

let ic = Interrupt_controller.create
    ~ie_addr:(Uint16.of_int 0xFFFF)
    ~if_addr:(Uint16.of_int 0xFF0F)

let%expect_test "test initial value" =
  let addr = (Uint16.of_int 0xFF00) in
  let t = Joypad.create ~addr ~ic in

  Joypad.read_byte t addr
  |> Uint8.show
  |> print_endline;

  [%expect {| $DF |}]
