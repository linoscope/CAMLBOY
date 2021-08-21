open Uints
module Bytes = BytesLabels

type t = bytes

let create ~start_addr ~end_addr = Bytes.create Uint16.(to_int @@ end_addr - start_addr)

let read_byte t addr =
  let addr = Uint16.to_int addr in
  Bytes.get_int8 t addr |> Uint8.of_int

let write_byte t ~addr ~data =
  Bytes.set_int8 t (Uint16.to_int addr) (Uint8.to_int data)
