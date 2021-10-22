type t = {
  cartridge_type : Cartridge_type.t;
  rom_bank_count : int;
  ram_bank_count : int;
}

let create ~rom_bytes =
  let cartridge_type =
    let open Cartridge_type in
    match Bytes.get_int8 rom_bytes 0x147 with
    | 0x00 -> ROM_ONLY
    | 0x01 -> MBC1
    | 0x02 -> MBC1_RAM
    | 0x03 -> MBC1_RAM_BATTERY
    | 0x05 -> MBC2
    | 0x06 -> MBC2_BATTERY
    | 0x0F -> MBC3_TIMER_BATTERY
    | 0x10 -> MBC3_TIMER_RAM_BATTERY
    | 0x11 -> MBC3
    |    x -> raise @@ Invalid_argument (Printf.sprintf "Unknown rom type : 0x%x" x)
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
    match Bytes.get_int8 rom_bytes 0x149 with
    | 0x00 -> 0
    | 0x01 -> 1
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

