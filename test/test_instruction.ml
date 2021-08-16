include Camlboy_lib
open Ints


let%expect_test "show instruction" =
  LD ((R_direct Registers.A), (FF00_offset (Uint8.of_int 0x1A)))
  |> Instruction.show
  |> print_endline;

  [%expect {| LD A, (0xFF00+0x1a) |}];

  BIT (Uint8.one, R_direct Registers.B)
  |> Instruction.show
  |> print_endline;

  [%expect {| BIT 0x01, B |}];

  RST (0x10 |> Uint16.of_int)
  |> Instruction.show
  |> print_endline;

  [%expect {| RST 0x0010 |}]
