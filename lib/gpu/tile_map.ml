open Uints

type t = {
  ram : Ram.t;
  area0_start_addr : uint16;
  area1_start_addr : uint16;
}

type area =
  | Area0
  | Area1

let create ~tile_map_ram ~area0_start_addr ~area1_start_addr = {
  ram = tile_map_ram;
  area0_start_addr;
  area1_start_addr;
}

let get_tile t ~area ~i ~j =
  let offset = match area with
    | Area0 -> t.area0_start_addr
    | Area1 -> t.area1_start_addr
  in
  let index = i * 32 + j |> Uint16.of_int in
  Ram.read_byte t.ram Uint16.(offset + index) |> Uint8.to_int

let accepts t = Ram.accepts t.ram

let read_byte t = Ram.read_byte t.ram

let write_byte t = Ram.write_byte t.ram
