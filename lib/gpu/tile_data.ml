open Uints

type set = Set1 | Set2

(* TODO:
 *  Maintain a internal representation of the tile set in where
 *  the pixel value has been pre-calculated.
 *  *)
type t = {
  tile_set_ram : Ram.t;
  set1_start_addr : uint16;
  set2_start_addr : uint16;
}

let create ~tile_set_ram ~set1_start_addr ~set2_start_addr = {
  tile_set_ram;
  set1_start_addr;
  set2_start_addr;
}

let get_row_pixels t ~set ~index ~row =
  let row_offset = 2 * row |> Uint16.of_int in
  let low_bit_row_addr = match set with
    | Set1 ->
      Uint16.(t.set1_start_addr + of_int 16 * of_int index + row_offset)
    | Set2 when index < 0 ->
      Uint16.(t.set2_start_addr - of_int 16 * of_int (abs index) + row_offset)
    | Set2 ->
      Uint16.(t.set2_start_addr + of_int 16 * of_int index + row_offset)
  in
  let hi_bit_row_addr  = Uint16.(low_bit_row_addr + one) in
  let low_bit_row = Ram.read_byte t.tile_set_ram low_bit_row_addr |> Uint8.to_int in
  let hi_bit_row  = Ram.read_byte t.tile_set_ram hi_bit_row_addr |> Uint8.to_int in
  [7; 6; 5; 4; 3; 2; 1; 0]
  |> List.map (fun i ->
      let hi_bit  = (hi_bit_row lsr i) land 1 = 1 in
      let low_bit = (low_bit_row lsr i) land 1 = 1 in
      Color_id.of_bits ~hi:hi_bit ~lo:low_bit)

let accepts t addr = Ram.accepts t.tile_set_ram addr

let read_byte t addr = Ram.read_byte t.tile_set_ram addr

let write_byte t ~addr ~data = Ram.write_byte t.tile_set_ram ~addr ~data
