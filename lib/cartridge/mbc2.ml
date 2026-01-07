(* MBC2 - Memory Bank Controller 2

   Features:
   - Up to 256KB ROM (16 banks)
   - Built-in 512×4 bits RAM (only lower nibble used)
   - RAM at 0xA000-0xA1FF (mirrored in 0xA200-0xBFFF)

   Register writes:
   - 0x0000-0x3FFF with bit 8 = 0: RAM enable (0x0A enables)
   - 0x0000-0x3FFF with bit 8 = 1: ROM bank number (4 bits, 0→1)

   Reference: https://gbdev.io/pandocs/MBC2.html *)

open Uints

type t = {
  rom_bytes : Bigstringaf.t;
  ram_bytes : Bigstringaf.t;
  rom_bank_count : int;
  mutable ram_enabled : bool;
  mutable rom_bank_num : int;
}

let create ~rom_bytes =
  let h = Cartridge_header.create ~rom_bytes in
  let rom_bank_count = Cartridge_header.get_rom_bank_count h in
  (* MBC2 has built-in 512×4 bit RAM *)
  let ram_bytes = Bigstringaf.create 512 in
  {
    rom_bytes;
    ram_bytes;
    rom_bank_count;
    ram_enabled = false;
    rom_bank_num = 1;
  }

let read_byte t addr =
  let addr = Uint16.to_int addr in
  match addr with
  | _ when addr <= 0x3FFF ->
    Bigstringaf.unsafe_get t.rom_bytes addr
    |> Uint8.of_char
  | _ when addr <= 0x7FFF ->
    let offset = 0x4000 * t.rom_bank_num + (addr - 0x4000) in
    Bigstringaf.unsafe_get t.rom_bytes offset
    |> Uint8.of_char
  | _ when 0xA000 <= addr && addr <= 0xBFFF ->
    (* RAM - 512 bytes mirrored, only lower 4 bits valid
       This memory is at A000–A1FF and mirrored at
       A200–BFFF hence the 0x1FF below. *)
    if t.ram_enabled then
      let ram_addr = (addr - 0xA000) land 0x1FF in
      let value = Bigstringaf.unsafe_get t.ram_bytes ram_addr |> Char.code in
      Uint8.of_int (value lor 0xF0)  (* Upper 4 bits read as 1 *)
    else
      Uint8.of_int 0xFF
  | _ -> assert false

let write_byte t ~addr ~data =
  let addr = Uint16.to_int addr in
  let data = Uint8.to_int data in
  match addr with
  | _ when addr <= 0x3FFF ->
    if addr land 0x100 = 0 then
      t.ram_enabled <- (data land 0x0F) = 0x0A
    else begin
      let bank = data land 0x0F in
      let bank = if bank = 0 then 1 else bank in
      t.rom_bank_num <- bank mod t.rom_bank_count
    end
  | _ when 0x4000 <= addr && addr <= 0x7FFF ->
    (* Writes to this area do nothing on MBC2 *)
    ()
  | _ when 0xA000 <= addr && addr <= 0xBFFF ->
    (* RAM - only lower 4 bits written *)
    if t.ram_enabled then begin
      let ram_addr = (addr - 0xA000) land 0x1FF in
      Bigstringaf.unsafe_set t.ram_bytes ram_addr (Char.unsafe_chr (data land 0x0F))
    end
  | _ -> assert false

let accepts _ addr =
  let addr = Uint16.to_int addr in
  (addr <= 0x7FFF) || (0xA000 <= addr && addr <= 0xBFFF)
