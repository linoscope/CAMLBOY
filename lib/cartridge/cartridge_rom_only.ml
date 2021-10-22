open Uints
module Bytes = BytesLabels

type t = { rom_bytes : bytes; }

let create ~rom_bytes = { rom_bytes; }

let read_byte t addr =
  let addr = Uint16.to_int addr in
  if (0x0000 <= addr && addr <= 0x7FFF) then
    Bytes.get_int8 t.rom_bytes addr |> Uint8.of_int
  else
    raise @@ Invalid_argument "Address out of bounds"

let write_byte _ ~addr:_ ~data:_ = ()

let accepts _ addr =
  let addr = Uint16.to_int addr in
  (0x0000 <= addr && addr <= 0x7FFF)
