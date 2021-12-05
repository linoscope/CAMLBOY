open Camlboy_lib
open Uints
open Base

let%expect_test "test bitflags_of_byte" =
  Uint8.of_int 0x91
  |> Bit_util.bitflags_of_byte
  |> [%sexp_of : bool * bool * bool * bool * bool * bool * bool * bool]
  |> Sexp.to_string
  |> Stdio.print_endline;

  [%expect {| (true false false true false false false true) |}]

let%expect_test "test byte_of_bitflags" =
  Bit_util.byte_of_bitflags true false false true false false false true
  |> Uint8.show
  |> Stdio.prerr_endline;

  [%expect {| $91 |}]
