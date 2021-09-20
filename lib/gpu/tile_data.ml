open Uints

type area = Area0 | Area1

(* TODO:
 *  Maintain a internal representation of the tile set in where
 *  the pixel value has been pre-calculated.
 *  *)
type t = {
  tile_data_ram : Ram.t;
  area0_start_addr : uint16;
  area1_start_addr : uint16;
}

let create ~tile_data_ram ~area0_start_addr ~area1_start_addr = {
  tile_data_ram;
  area0_start_addr;
  area1_start_addr;
}

let get_row_pixels t ~area ~index ~row =
  let row_offset = 2 * row |> Uint16.of_int in
  let low_bit_row_addr = match area with
    | Area0 ->
      Uint16.(t.area0_start_addr + of_int 16 * of_int index + row_offset)
    | Area1 when index < 0 ->
      Uint16.(t.area1_start_addr - of_int 16 * of_int (abs index) + row_offset)
    | Area1 ->
      Uint16.(t.area1_start_addr + of_int 16 * of_int index + row_offset)
  in
  let hi_bit_row_addr  = Uint16.(low_bit_row_addr + one) in
  let low_bit_row = Ram.read_byte t.tile_data_ram low_bit_row_addr |> Uint8.to_int in
  let hi_bit_row  = Ram.read_byte t.tile_data_ram hi_bit_row_addr |> Uint8.to_int in
  [7; 6; 5; 4; 3; 2; 1; 0]
  |> List.map (fun i ->
      let hi_bit  = (hi_bit_row lsr i) land 1 = 1 in
      let low_bit = (low_bit_row lsr i) land 1 = 1 in
      Color_id.of_bits ~hi:hi_bit ~lo:low_bit)

let accepts t addr = Ram.accepts t.tile_data_ram addr

let read_byte t addr = Ram.read_byte t.tile_data_ram addr

let write_byte t ~addr ~data = Ram.write_byte t.tile_data_ram ~addr ~data
