open Uints
module Bytes = BytesLabels

type t = {
  bytes : bytes;
  rom_start_addr : uint16;
  rom_end_addr : uint16;
  rom_bank_start_addr : uint16;
  rom_bank_end_addr : uint16;
  ram_bank_start_addr : uint16;
  ram_bank_end_addr : uint16;
}

let create
    ~rom_bytes
    ~rom_start_addr
    ~rom_end_addr
    ~rom_bank_start_addr
    ~rom_bank_end_addr
    ~ram_bank_start_addr
    ~ram_bank_end_addr =
  {
    bytes = rom_bytes;
    rom_start_addr;
    rom_end_addr;
    rom_bank_start_addr;
    rom_bank_end_addr;
    ram_bank_start_addr;
    ram_bank_end_addr;
  }

let read_byte t addr =
  if Uint16.(t.rom_start_addr <= addr && addr <= t.rom_bank_end_addr) then
    let offset = Uint16.(addr - t.rom_start_addr) |> Uint16.to_int in
    Bytes.get_int8 t.bytes offset |> Uint8.of_int
  else
    raise @@ Invalid_argument "Address out of bounds"

let write_byte _ ~addr:_ ~data:_ = ()

let accepts t addr =
  Uint16.(t.rom_start_addr <= addr && addr <= t.rom_end_addr)
  || Uint16.(t.rom_bank_start_addr <= addr && addr <= t.rom_bank_end_addr)
  || Uint16.(t.ram_bank_start_addr <= addr && addr <= t.ram_bank_end_addr)
