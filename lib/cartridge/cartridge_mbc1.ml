open Uints

type mode = F0 | F1

type t = {
  rom_bytes : Bigstringaf.t;
  ram_bytes : Bigstringaf.t;
  rom_bank_size : int;
  ram_bank_size : int;
  mutable ram_enabled : bool;
  mutable rom_bank_num : int;
  mutable ram_bank_num : int;
  mutable mode : mode;
}

let create ~rom_bytes =
  let h = Cartridge_header.create ~rom_bytes in
  let rom_bank_size = Cartridge_header.get_rom_bank_count h in
  let ram_bank_size = Cartridge_header.get_ram_bank_count h in
  let ram_bytes = Bigstringaf.create (ram_bank_size * 0x2000) in
  {
    rom_bytes;
    ram_bytes;
    rom_bank_size;
    ram_bank_size;
    ram_enabled = false;
    rom_bank_num = 1;
    ram_bank_num = 0;
    mode = F0;
  }

(* https://hacktixme.ga/GBEDG/mbcs/mbc1/#zero-bank *)
let zero_bank_num t =
  match t.mode, t.rom_bank_size with
  | F0, _              -> 0
  | F1, n when n <= 32 -> 0
  | F1, n when n =  64 -> (t.ram_bank_num land 0b1) lsl 5
  | F1, n when n = 128 -> (t.ram_bank_num land 0b11) lsl 5
  | F1, _ -> assert false

(* https://hacktixme.ga/GBEDG/mbcs/mbc1/#high-bank *)
let high_bank_num t =
  match t.rom_bank_size with
  | n when n <= 32 -> t.rom_bank_num
  | n when n =  64 ->
    let bit5  = (t.ram_bank_num land 0b1) lsl 5 in
    bit5 lor t.rom_bank_num
  | n when n = 128 ->
    let bit56 = (t.ram_bank_num land 0b11) lsl 5 in
    bit56 lor t.rom_bank_num
  | _ -> assert false

let ram_addr_of_addr t addr =
  match t.mode, t.ram_bank_size with
  | F0, _
  | F1, 1 ->
    (addr - 0xA000) mod 0x2000
  | F1, 4 ->
    0x2000 * t.ram_bank_num + (addr - 0xA000)
  | F1, n ->
    raise @@ Invalid_argument (Printf.sprintf "Unexpected ram size: %d" n)

let read_byte t addr =
  let addr = Uint16.to_int addr in
  match addr with
  | _ when 0x0000 <= addr && addr <= 0x3FFF ->
    let zero_bank_num = zero_bank_num t in
    (0x4000 * zero_bank_num + addr)
    |> Bigstringaf.get t.rom_bytes
    |> Uint8.of_char
  | _ when 0x4000 <= addr && addr <= 0x7FFF ->
    let high_bank_num = high_bank_num t in
    (0x4000 * high_bank_num + (addr - 0x4000))
    |> Bigstringaf.get t.rom_bytes
    |> Uint8.of_char
  | _ when 0xA000 <= addr && addr <= 0xBFFF ->
    if t.ram_enabled && t.ram_bank_size > 0 then
      addr
      |> ram_addr_of_addr t
      |> Bigstringaf.get t.ram_bytes
      |> Uint8.of_char
    else
      Uint8.of_int 0xFF
  | _ -> assert false


let bitmask_of_rom_size = function
  | 2   -> 0b00000001
  | 4   -> 0b00000011
  | 8   -> 0b00000111
  | 16  -> 0b00001111
  | 32  -> 0b00011111
  | 64  -> 0b00011111
  | 128 -> 0b00011111
  | n -> raise @@ Invalid_argument (Printf.sprintf "Unexpected rom size: %d" n)

let write_byte t ~addr ~data =
  let addr = Uint16.to_int addr in
  let data = Uint8.to_int data in
  match addr with
  | _ when 0x0000 <= addr && addr <= 0x1FFF ->
    t.ram_enabled <- data = 0x0A
  | _ when 0x2000 <= addr && addr <= 0x3FFF ->
    let rom_bank_num = data land (bitmask_of_rom_size t.rom_bank_size) in
    t.rom_bank_num <- if rom_bank_num = 0 then 1 else rom_bank_num
  | _ when 0x4000 <= addr && addr <= 0x5FFF ->
    t.ram_bank_num <- data land 0b11
  | _ when 0x6000 <= addr && addr <= 0x7FFF ->
    t.mode <- if data land 1 = 0 then F0 else F1
  | _ when 0xA000 <= addr && addr <= 0xBFFF ->
    if t.ram_enabled && t.ram_bank_size > 0  then
      let ram_addr = addr |> ram_addr_of_addr t in
      Bigstringaf.set t.ram_bytes ram_addr (Char.unsafe_chr data)
  | _ -> assert false

let accepts _ addr =
  let addr = Uint16.to_int addr in
  0x0000 <= addr && addr <= 0x7FFF ||  0xA000 <= addr && addr <= 0xBFFF
