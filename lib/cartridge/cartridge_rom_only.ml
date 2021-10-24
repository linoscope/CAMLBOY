open Uints

type t = { rom_bytes : Bigstringaf.t; }

let create ~rom_bytes = { rom_bytes; }

let read_byte t addr =
  let addr = Uint16.to_int addr in
  if (0x0000 <= addr && addr <= 0x7FFF) then
    Bigstringaf.get t.rom_bytes addr
    |> Uint8.of_char
  else
    raise @@ Invalid_argument "Address out of bounds"

let write_byte _ ~addr:_ ~data:_ = ()

let accepts _ addr =
  let addr = Uint16.to_int addr in
  (0x0000 <= addr && addr <= 0x7FFF)
