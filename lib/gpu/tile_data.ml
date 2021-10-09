open Uints

type area = Area1 | Area0

(* TODO:
 *  Maintain a internal representation of the tile set in where
 *  the pixel value has been pre-calculated.
 *  *)
type t = {
  tile_data_ram : Ram.t;
  area1_start_addr : uint16;
  area0_start_addr : uint16;
}

let create ~tile_data_ram ~area1_start_addr ~area0_start_addr = {
  tile_data_ram;
  area1_start_addr;
  area0_start_addr;
}

let get_pixel t ~area ~index ~row ~col =
  let index = Int8.to_int index in
  let row_offset = 2 * row |> Uint16.of_int in
  let low_bit_row_addr = match area with
    | Area1 ->
      Uint16.(t.area1_start_addr + of_int 16 * of_int index + row_offset)
    | Area0 when index < 0 ->
      Uint16.(t.area0_start_addr - of_int 16 * of_int (abs index) + row_offset)
    | Area0 ->
      Uint16.(t.area0_start_addr + of_int 16 * of_int index + row_offset)
  in
  let hi_bit_row_addr  = Uint16.(low_bit_row_addr + one) in
  let low_bit_row = Ram.read_byte t.tile_data_ram low_bit_row_addr |> Uint8.to_int in
  let hi_bit_row  = Ram.read_byte t.tile_data_ram hi_bit_row_addr |> Uint8.to_int in
  let i = 7 - col in
  let hi_bit  = (hi_bit_row lsr i) land 1 = 1 in
  let low_bit = (low_bit_row lsr i) land 1 = 1 in
  Color_id.of_bits ~hi:hi_bit ~lo:low_bit

let get_row_pixels t ~area ~index ~row =
  [| 0; 1; 2; 3; 4; 5; 6; 7 |]
  |> Array.map (fun col -> get_pixel t ~area ~index ~row ~col)

let get_full_pixels t ~area ~index =
  [| 0; 1; 2; 3; 4; 5; 6; 7 |]
  |> Array.map (fun row-> get_row_pixels t ~area ~index ~row)

let print_full_pixels t ~area ~index =
  get_full_pixels t ~area ~index
  |> Array.iter (fun color_ids ->
      color_ids
      |> Array.map (Color_id.to_int)
      |> Array.iter (print_int);
      print_newline ()
    )


let accepts t addr = Ram.accepts t.tile_data_ram addr

let read_byte t addr = Ram.read_byte t.tile_data_ram addr

let write_byte t ~addr ~data = Ram.write_byte t.tile_data_ram ~addr ~data
