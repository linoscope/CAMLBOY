open Camlboy_lib
open Uints

let%expect_test "signed int8 (negative number)" =
  let byte = Uint8.of_int 0xFB in

  let i8 = Int8.of_byte byte in
  Int8.to_int i8
  |> Printf.printf "%d";

  [%expect {|-5|}];

  i8
  |> Int8.abs
  |> Int8.to_int
  |> Printf.printf "%d";

  [%expect {|5|}]


let%expect_test "signed int8 (positive number)" =
  let byte = Uint8.of_int 0x05 in

  let i8 = Int8.of_byte byte in
  Int8.to_int i8
  |> Printf.printf "%d";

  [%expect {|5|}]

let%expect_test "signed int8 (of_int -> to_int)" =
  -5
  |> Int8.of_int
  |> Int8.to_int
  |> Printf.printf "%d";

  [%expect {|-5|}]

let%expect_test "signed int8 (of_int -> to_int)" =
  -128
  |> Int8.of_int
  |> Int8.to_int
  |> Printf.printf "%d";

  [%expect {|-128|}]
