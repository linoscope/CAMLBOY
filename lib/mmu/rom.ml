open Uints
module Bytes = BytesLabels

type t = {
  bytes : bytes;
  start_addr : uint16;
  end_addr : uint16;
}

let create ~start_addr ~end_addr = {
  bytes = Bytes.make Uint16.(to_int @@ end_addr - start_addr + one) (Char.chr 0);
  start_addr;
  end_addr;
}

let load t ~rom_bytes  =
  Bytes.blit ~src:rom_bytes ~src_pos:0 ~dst:t.bytes ~dst_pos:0 ~len:(Bytes.length rom_bytes)

let read_byte t addr =
  let offset = Uint16.(addr - t.start_addr) |> Uint16.to_int in
  Bytes.get_int8 t.bytes offset |> Uint8.of_int

let write_byte _ ~addr ~data =
  failwith @@
  Printf.sprintf "Write to ROM not allowed. addr:%s, data:%s"
    (Uint16.show addr) (Uint8.show data)

let accepts t ~addr = Uint16.(t.start_addr <= addr && addr <= t.end_addr)
