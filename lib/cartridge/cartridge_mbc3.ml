open Uints

(* TODO: Support Real Time Clock (RTC) and battery backed save *)

type t = {
  rom_bytes : Bigstringaf.t;
  ram_bytes : Bigstringaf.t;
  mutable ram_enabled : bool;
  mutable rom_bank_num : int;
  mutable ram_bank_num : int;
}

let create ~rom_bytes =
  let h = Cartridge_header.create ~rom_bytes in
  let ram_bank_size = Cartridge_header.get_ram_bank_count h in
  let ram_bytes = Bigstringaf.create (ram_bank_size * 0x2000) in
  {
    rom_bytes;
    ram_bytes;
    ram_enabled = false;
    rom_bank_num = 1;
    ram_bank_num = 0;
  }

let read_byte t addr =
  let addr = Uint16.to_int addr in
  match addr with
  | _ when 0x0000 <= addr && addr <= 0x3FFF ->
    addr
    |> Bigstringaf.unsafe_get t.rom_bytes
    |> Uint8.of_char
  | _ when 0x4000 <= addr && addr <= 0x7FFF ->
    (0x4000 * t.rom_bank_num + (addr - 0x4000))
    |> Bigstringaf.unsafe_get t.rom_bytes
    |> Uint8.of_char
  | _ when 0xA000 <= addr && addr <= 0xBFFF ->
    if t.ram_enabled then
      0x4000 * t.rom_bank_num + (addr - 0x4000)
      |> Bigstringaf.unsafe_get t.ram_bytes
      |> Uint8.of_char
    else
      Uint8.of_int 0xFF
  | _ -> assert false


let write_byte t ~addr ~data =
  let addr = Uint16.to_int addr in
  let data = Uint8.to_int data in
  match addr with
  | _ when 0x0000 <= addr && addr <= 0x1FFF ->
    t.ram_enabled <- data = 0x0A
  | _ when 0x2000 <= addr && addr <= 0x3FFF ->
    let rom_bank_num = data land 0b01111111 in
    t.rom_bank_num <- if rom_bank_num = 0 then 1 else rom_bank_num
  | _ when 0x4000 <= addr && addr <= 0x5FFF ->
    if 0x0 <= data && data <= 0x3 then t.ram_bank_num <- data
  | _ when 0x6000 <= addr && addr <= 0x7FFF ->
    (* No RTC support yet *)
    ()
  | _ when 0xA000 <= addr && addr <= 0xBFFF ->
    if t.ram_enabled then
      let ram_addr = 0x4000 * t.rom_bank_num + (addr - 0x4000) in
      Bigstringaf.unsafe_set t.ram_bytes ram_addr (Char.unsafe_chr data)
  | _ -> assert false

let accepts _ addr =
  let addr = Uint16.to_int addr in
  0x0000 <= addr && addr <= 0x7FFF ||  0xA000 <= addr && addr <= 0xBFFF
