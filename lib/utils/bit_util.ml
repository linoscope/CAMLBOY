open Uints
open StdLabels

let bitflags_of_byte x =
  let open Uint8 in
  (
    (x land of_int 0b10000000) <> zero,
    (x land of_int 0b01000000) <> zero,
    (x land of_int 0b00100000) <> zero,
    (x land of_int 0b00010000) <> zero,
    (x land of_int 0b00001000) <> zero,
    (x land of_int 0b00000100) <> zero,
    (x land of_int 0b00000010) <> zero,
    (x land of_int 0b00000001) <> zero
  )

let byte_of_bitflags b7 b6 b5 b4 b3 b2 b1 b0 =
  Bool.to_int b0
  lor (Bool.to_int b1 lsl 1)
  lor (Bool.to_int b2 lsl 2)
  lor (Bool.to_int b3 lsl 3)
  lor (Bool.to_int b4 lsl 4)
  lor (Bool.to_int b5 lsl 5)
  lor (Bool.to_int b6 lsl 6)
  lor (Bool.to_int b7 lsl 7)
  |> Uint8.of_int

let bitarray_of_byte x =
  let open Uint8 in
  [|
    (x land of_int 0b10000000) <> zero;
    (x land of_int 0b01000000) <> zero;
    (x land of_int 0b00100000) <> zero;
    (x land of_int 0b00010000) <> zero;
    (x land of_int 0b00001000) <> zero;
    (x land of_int 0b00000100) <> zero;
    (x land of_int 0b00000010) <> zero;
    (x land of_int 0b00000001) <> zero
  |]

let byte_of_bitarray a =
  [|7; 6; 5; 4; 3; 2; 1; 0|]
  |> Array.fold_left ~init:0 ~f:(fun acc i ->
      acc lor (Bool.to_int a.(i) lsl i))
  |> Uint8.of_int
