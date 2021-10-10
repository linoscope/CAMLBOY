type cartridge_type = [`ROM_ONLY | `NO_MBC | `MBC1]

type t = {
  cartridge_type : cartridge_type;
  rom_bank_count : int;
  ram_bank_count : int;
}

let create ~rom_bytes =
  let cartridge_type =
    match Bytes.get_int8 rom_bytes 0x147 with
    | 0x00 -> `ROM_ONLY
    | 0x01 -> `MBC1
    | 0x08 -> `NO_MBC
    | _ -> assert false
  in
  let rom_bank_count =
    match Bytes.get_int8 rom_bytes 0x148 with
    | 0x00 -> 2
    | 0x01 -> 4
    | 0x02 -> 8
    | 0x03 -> 16
    | 0x04 -> 32
    | 0x05 -> 64
    | 0x06 -> 128
    | 0x07 -> 256
    | 0x08 -> 512
    | _ -> assert false
  in
  let ram_bank_count =
    match Bytes.get_int8 rom_bytes 0x148 with
    | 0x00 -> 0
    | 0x01 -> 0
    | 0x02 -> 1
    | 0x03 -> 4
    | 0x04 -> 16
    | 0x05 -> 8
    | _ -> assert false
  in
  { cartridge_type; rom_bank_count; ram_bank_count }

let get_cartridge_type t = t.cartridge_type

let get_rom_bank_count t = t.rom_bank_count

let get_ram_bank_count t = t.ram_bank_count
