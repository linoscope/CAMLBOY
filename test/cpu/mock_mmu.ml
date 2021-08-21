open Camlboy_lib
open Uints
module Bytes = BytesLabels

type t = bytes

let create ~size = Bytes.create size

let load t ~src ~dst_pos =
  Bytes.blit ~src ~src_pos:0 ~dst:t ~dst_pos:(Uint16.to_int dst_pos) ~len:(Bytes.length src)

let read_byte t addr =
  let addr = Uint16.to_int addr in
  Bytes.get_int8 t addr |> Uint8.of_int

let read_word t addr =
  let addr = Uint16.to_int addr in
  Bytes.get_int16_le t addr |> Uint16.of_int

let write_byte t ~addr ~data =
  Bytes.set_int8 t (Uint16.to_int addr) (Uint8.to_int data)

let write_word t ~addr ~data =
  Bytes.set_int16_le t (Uint16.to_int addr) (Uint16.to_int data)

let accepts _ ~addr:_ = true
