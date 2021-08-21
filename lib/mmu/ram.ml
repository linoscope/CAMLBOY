open Uints
module Bytes = BytesLabels

type t = {
  bytes : bytes;
  start_addr : uint16;
  end_addr : uint16;
}

let create ~start_addr ~end_addr = {
  bytes = Bytes.create Uint16.(to_int @@ end_addr - start_addr);
  start_addr;
  end_addr;
}

let read_byte t addr =
  let addr = Uint16.(addr - t.start_addr) |> Uint16.to_int in
  Bytes.get_int8 t.bytes addr |> Uint8.of_int

let write_byte t ~addr ~data =
  let addr = Uint16.(addr - t.start_addr) |> Uint16.to_int in
  Bytes.set_int8 t.bytes addr (Uint8.to_int data)

let accepts t ~addr = Uint16.(t.start_addr <= addr && addr <= t.end_addr)
