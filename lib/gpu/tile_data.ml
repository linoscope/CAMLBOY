open Uints

type area = Area1 | Area0

type t = {
  (* tiles.(i).(row).(col) : (row, col) of the i-th tile *)
  tiles : Color_id.t array array array;
  start_addr : uint16;
  end_addr : uint16;
}

let create ~start_addr ~end_addr =
  let tiles = Array.init 384 (fun _ -> Array.make_matrix 8 8 Color_id.ID_00) in
  {
    tiles;
    start_addr;
    end_addr;
  }

let get_row_pixels t ~area ~(index:uint8) ~row =
  let index = match area with
    | Area1 ->
      Uint8.to_int index
    | Area0 ->
      (* interpret unsigned int8 byte as signed int8 *)
      let signed_index = index |> Int8.of_byte |> Int8.to_int in
      signed_index + 256
  in
  if row >= 8 then
    t.tiles.(index + 1).(row - 8)
  else
    t.tiles.(index).(row)

(* TODO: napkin-math why this (and oam fetch) was the bottle neck *)
let get_pixel t ~area ~(index:uint8) ~row ~col =
  let row = get_row_pixels t ~area ~index ~row in
  row.(col)

let get_full_pixels t ~area ~index =
  [| 0; 1; 2; 3; 4; 5; 6; 7 |]
  |> Array.map (fun row-> get_row_pixels t ~area ~index ~row)

let print_full_pixels t ~area ~index =
  get_full_pixels t ~area ~index
  |> Array.iter (fun color_ids ->
      color_ids
      |> Array.map (Color_id.to_int)
      |> Array.iter (print_int);
      print_newline ())

let accepts t addr = Uint16.(t.start_addr <= addr && addr <= t.end_addr)

let read_byte t addr =
  let offset = Uint16.(addr - t.start_addr) |> Uint16.to_int in
  let index = offset / 16 in
  let row = (offset mod 16) / 2 in
  let hi_or_lo = if offset mod 2 = 0 then `Lo else `Hi in
  t.tiles.(index).(row)
  |> Array.map (fun id -> Color_id.get_bit id hi_or_lo)
  |> Bit_util.byte_of_bitarray

let write_byte t ~addr ~data =
  let data_bits = Bit_util.bitarray_of_byte data in
  let offset = Uint16.(addr - t.start_addr) |> Uint16.to_int in
  let index = offset / 16 in
  let row = (offset mod 16) / 2 in
  (* Printf.printf "offset=%d, index=%d, row=%d\n" offset index row; *)
  let colors_in_row = t.tiles.(index).(row) in
  let hi_or_lo = if offset mod 2 = 0 then `Lo else `Hi in
  t.tiles.(index).(row) <-
    data_bits
    |> Array.mapi (fun i b ->
        let id = colors_in_row.(i) in
        if b then
          Color_id.set_bit id hi_or_lo
        else
          Color_id.clear_bit id hi_or_lo)
