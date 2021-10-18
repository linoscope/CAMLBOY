open Uints

(* TODO: Properly handle modes: https://gbdev.io/pandocs/MBC1.html *)
type mode =
  | Rom_banking_mode
  | Ram_banking_mode

type t = {
  rom_bytes : bytes;
  ram_bytes : bytes;
  rom_bank_size : int;
  ram_bank_size : int;
  mutable ram_enabled : bool;
  mutable cur_rom_bank : int;
  mutable cur_ram_bank : int;
  mutable mode : mode;
  (* addresses *)
  rom_bank0_start_addr : uint16;
  rom_bank0_half_addr : uint16;
  rom_bank0_end_addr : uint16;
  rom_bank_start_addr : uint16;
  rom_bank_half_addr : uint16;
  rom_bank_end_addr : uint16;
  ram_bank_start_addr : uint16;
  ram_bank_end_addr : uint16;
}

let create
    ~rom_bytes
    ~rom_bank0_start_addr
    ~rom_bank0_end_addr
    ~rom_bank_start_addr
    ~rom_bank_end_addr
    ~ram_bank_start_addr
    ~ram_bank_end_addr
  =
  let rom_bank_size = Uint16.to_int rom_bank_end_addr - Uint16.to_int rom_bank_start_addr + 1 in
  let ram_bank_size = Uint16.to_int ram_bank_end_addr - Uint16.to_int ram_bank_start_addr + 1 in
  let rom_bank0_half_addr = Uint16.((rom_bank0_start_addr + rom_bank0_end_addr) / of_int 2) in
  let rom_bank_half_addr = Uint16.((rom_bank_start_addr + rom_bank_end_addr) / of_int 2) in
  let ram_bytes = Bytes.create (4 * ram_bank_size) in (* MBC1 can have up to 4 RAM banks *)
  {
    rom_bytes;
    ram_bytes;
    rom_bank_size;
    ram_bank_size;
    ram_enabled = true;
    cur_rom_bank = 1;
    cur_ram_bank = 0;
    mode = Rom_banking_mode;
    rom_bank0_start_addr;
    rom_bank0_half_addr;
    rom_bank0_end_addr;
    rom_bank_start_addr;
    rom_bank_half_addr;
    rom_bank_end_addr;
    ram_bank_start_addr;
    ram_bank_end_addr;
  }

let get_ram_addr t addr =
  let bank_base = t.cur_ram_bank * t.ram_bank_size in
  bank_base + Uint16.to_int addr - Uint16.to_int t.ram_bank_start_addr

let read_byte t addr =
  if Uint16.(t.rom_bank0_start_addr <= addr && addr <= t.rom_bank0_end_addr) then
    let rom_addr = Uint16.(addr - t.rom_bank0_start_addr) |> Uint16.to_int in
    Bytes.get_int8 t.rom_bytes rom_addr |> Uint8.of_int
  else if Uint16.(t.rom_bank_start_addr <= addr && addr <= t.rom_bank_end_addr) then
    let bank_base = ((t.cur_rom_bank - 1) * t.rom_bank_size) in
    let rom_addr = bank_base + Uint16.to_int addr - Uint16.to_int t.rom_bank0_start_addr in
    Bytes.get_int8 t.rom_bytes rom_addr |> Uint8.of_int
  else if Uint16.(t.ram_bank_start_addr <= addr && addr <= t.ram_bank_end_addr) then
    if t.ram_enabled then
      let ram_addr = get_ram_addr t addr in
      Bytes.get_int8 t.ram_bytes ram_addr |> Uint8.of_int
    else
      Uint8.of_int 0xFF
  else
    raise @@ Invalid_argument "Address out of bounds"

let write_byte t ~addr ~data =
  if Uint16.(t.rom_bank0_start_addr <= addr && addr <  t.rom_bank0_half_addr) then begin
    t.ram_enabled <- Uint8.(data = of_int 0x0A)
  end
  else if Uint16.(t.rom_bank0_half_addr <= addr && addr <= t.rom_bank0_end_addr) then begin
    if Uint8.(data = zero) then
      t.cur_ram_bank <- 1
    else
      let data = Uint8.to_int data in
      let bank = t.cur_rom_bank land 0b01100000 in
      let bank = bank lor (data land 0b00011111) in
      t.cur_rom_bank <- bank;
  end
  else if Uint16.(t.rom_bank_start_addr <= addr && addr < t.rom_bank_half_addr) then
    match t.mode with
    | Rom_banking_mode ->
      (* data is high 2 bits of ROM bank *)
      let data = Uint8.to_int data in
      let bank = t.cur_rom_bank land 0b00011111 in
      let bank = bank lor (data land 0b01100000) in
      t.cur_rom_bank <- bank;
    | Ram_banking_mode ->
      let bank = (Uint8.to_int data) land 0b11 in
      t.cur_ram_bank <- bank
  else if Uint16.(t.rom_bank_half_addr <= addr && addr <= t.rom_bank_end_addr) then
    t.mode <-
      if Uint8.(data land one = zero) then Rom_banking_mode else Ram_banking_mode
  else if Uint16.(t.ram_bank_start_addr <= addr && addr <= t.ram_bank_end_addr) then begin
    if t.ram_enabled then
      let ram_addr = get_ram_addr t addr in
      Bytes.set_int8 t.ram_bytes ram_addr (Uint8.to_int data)
  end else
    raise @@ Invalid_argument (Printf.sprintf "Address out of bounds: %s" (addr |> Uint16.show))


let accepts t addr =
  Uint16.(t.rom_bank0_start_addr <= addr && addr <= t.rom_bank0_end_addr)
  || Uint16.(t.rom_bank_start_addr <= addr && addr <= t.rom_bank_end_addr)
  || Uint16.(t.ram_bank_start_addr <= addr && addr <= t.ram_bank_end_addr)
