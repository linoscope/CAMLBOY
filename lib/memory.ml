open Ints

type t = bytes

let read_byte t addr =
  let addr = Uint16.to_int addr in
  Bytes.get_int8 t addr |> Uint8.of_int

let read_word t addr =
  let addr = Uint16.to_int addr in
  Bytes.get_int16_le t addr |> Uint16.of_int
