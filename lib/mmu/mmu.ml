open Uints
module Bytes = BytesLabels
open StdLabels

type t = {
  rom : bytes;
}

let create ~size = {
  rom = Bytes.create size;
}

let load t ~src ~dst_pos =
  Bytes.blit ~src ~src_pos:0 ~dst:t.rom ~dst_pos:(Uint16.to_int dst_pos) ~len:(Bytes.length src)

let read_byte t addr =
  let addr = Uint16.to_int addr in
  Bytes.get_int8 t.rom addr |> Uint8.of_int

let read_word t addr =
  let addr = Uint16.to_int addr in
  Bytes.get_int16_le t.rom addr |> Uint16.of_int

let write_byte t ~addr ~data =
  Bytes.set_int8 t.rom (Uint16.to_int addr) (Uint8.to_int data)

let write_word t ~addr ~data =
  Bytes.set_int16_le t.rom (Uint16.to_int addr) (Uint16.to_int data)

let show t =
  let buf = Buffer.create (2 * Bytes.length t.rom) in
  Bytes.iter t.rom ~f:(fun c -> Printf.sprintf "%02x " (Char.code c) |> Buffer.add_string buf);
  Buffer.contents buf

let pp fmt t = Format.fprintf fmt "%s" (show t)
