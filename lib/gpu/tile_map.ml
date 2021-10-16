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

let get_tile_index t ~area ~y ~x =
  let start_addr = match area with
    | Area0 -> t.area0_start_addr
    | Area1 -> t.area1_start_addr
  in
  let offset = (y / 8) * 32 + (x / 8) |> Uint16.of_int in
  Ram.read_byte t.ram Uint16.(start_addr + offset)

let accepts t = Ram.accepts t.ram

let read_byte t = Ram.read_byte t.ram

let write_byte t = Ram.write_byte t.ram
