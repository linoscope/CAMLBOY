open Uints
module Bytes = BytesLabels

type t = bytes

let create ~start_addr ~end_addr = Bytes.create Uint16.(to_int @@ end_addr - start_addr)

let load t ~rom_bytes  =
  Bytes.blit ~src:rom_bytes ~src_pos:0 ~dst:t ~dst_pos:0 ~len:(Bytes.length rom_bytes)


let read_byte t addr =
  let addr = Uint16.to_int addr in
  Bytes.get_int8 t addr |> Uint8.of_int

let write_byte _ ~addr ~data =
  failwith @@ Printf.sprintf "Write to ROM not allowed. addr:%s, data:%s" (Uint16.show addr) (Uint8.show data)
