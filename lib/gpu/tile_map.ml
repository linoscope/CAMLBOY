open Uints

type t = {
  area0_map : uint8 array array;
  area1_map : uint8 array array;
  area0_start_addr : uint16;
  area0_end_addr   : uint16;
  area1_start_addr : uint16;
  area1_end_addr   : uint16;
}

type area =
  | Area0
  | Area1

let create ~area0_start_addr ~area0_end_addr ~area1_start_addr ~area1_end_addr = {
  area0_map = Array.make_matrix 32 32 Uint8.zero;
  area1_map = Array.make_matrix 32 32 Uint8.zero;
  area0_start_addr;
  area0_end_addr;
  area1_start_addr;
  area1_end_addr;
}

let get_tile_index t ~area ~y ~x =
  match area with
  | Area0 -> t.area0_map.(y / 8).(x / 8)
  | Area1 -> t.area1_map.(y / 8).(x / 8)

let accepts t addr =
  Uint16.(t.area0_start_addr <= addr && addr <= t.area0_end_addr
          || t.area1_start_addr <= addr && addr <= t.area1_end_addr)

let read_byte t addr =
  if Uint16.(t.area0_start_addr <= addr && addr <= t.area0_end_addr) then
    let offset = Uint16.(to_int (addr - t.area0_start_addr)) in
    t.area0_map.(offset / 32).(offset mod 32)
  else if Uint16.(t.area1_start_addr <= addr && addr <= t.area1_end_addr) then
    let offset = Uint16.(to_int (addr - t.area1_start_addr)) in
    t.area1_map.(offset / 32).(offset mod 32)
  else
    raise @@ Invalid_argument (Printf.sprintf "Address out of range: %s" (Uint16.show addr))

let write_byte t ~addr ~data =
  if Uint16.(t.area0_start_addr <= addr && addr <= t.area0_end_addr) then
    let offset = Uint16.(to_int (addr - t.area0_start_addr)) in
    t.area0_map.(offset / 32).(offset mod 32) <- data
  else if Uint16.(t.area1_start_addr <= addr && addr <= t.area1_end_addr) then
    let offset = Uint16.(to_int (addr - t.area1_start_addr)) in
    t.area1_map.(offset / 32).(offset mod 32) <- data
  else
    raise @@ Invalid_argument (Printf.sprintf "Address out of range: %s" (Uint16.show addr))
