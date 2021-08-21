open Uints
module Bytes = BytesLabels
open StdLabels

module Make (Gpu : Addressable_intf.S) = struct

  type t = {
    rom_bank_0 : bytes;
    ram : bytes;
    gpu : Gpu.t;
    zero_page : bytes;
  }

  type region =
    | Rom_bank_0
    | Ram
    | Shadow_ram
    | Gpu_region
    | Zero_page

  let region_of_addr = function
    | addr when 0x0000 <= addr && addr <= 0x3FFF -> Rom_bank_0
    | addr when 0xC000 <= addr && addr <= 0xDFFF -> Ram
    | addr when 0xE000 <= addr && addr <= 0xFDFF -> Shadow_ram
    | addr when 0x8000 <= addr && addr <= 0x9FFF -> Gpu_region
    | addr when 0xFF80 <= addr && addr <= 0xFFFF -> Zero_page
    | addr -> failwith @@ Printf.sprintf "Unmapped address : 0x%04x"  addr

  let create ~gpu = {
    rom_bank_0 = Bytes.create (0x3FFF - 0x0000);
    ram = Bytes.create (0xDFFF - 0xC000);
    gpu;
    zero_page = Bytes.create (0xFFFF - 0xFF80);
  }

  let load_rom t ~rom  =
    Bytes.blit ~src:rom ~src_pos:0 ~dst:t.rom_bank_0 ~dst_pos:0 ~len:(Bytes.length rom)

  let read_byte t addr =
    let addr = Uint16.to_int addr in
    match region_of_addr addr with
    | Rom_bank_0       -> Bytes.get_int8 t.rom_bank_0 addr |> Uint8.of_int
    | Ram | Shadow_ram -> Bytes.get_int8 t.ram addr |> Uint8.of_int
    | Gpu_region       -> Gpu.read_byte t.gpu (Uint16.of_int addr)
    | Zero_page        -> Bytes.get_int8 t.zero_page addr |> Uint8.of_int


  let write_byte t ~(addr : Uint16.t) ~data =
    let addr = Uint16.to_int addr in
    let data = Uint8.to_int data in
    match region_of_addr addr with
    | Rom_bank_0       -> Bytes.set_int8 t.rom_bank_0 addr data
    | Ram | Shadow_ram -> Bytes.set_int8 t.ram addr data
    | Gpu_region       -> Gpu.write_byte t.gpu ~addr:(Uint16.of_int addr) ~data:(Uint8.of_int data)
    | Zero_page        -> Bytes.set_int8 t.zero_page addr data

  let read_word t addr =
    Uint8.(read_byte t addr + read_byte t Uint16.(succ addr) lsl 8)
    |> Uint16.of_uint8

  let write_word t ~addr ~(data : uint16) =
    let data = Uint16.to_int data in
    let hi = data lsr 8 |> Uint8.of_int in
    let lo = data land 0xF |> Uint8.of_int in
    write_byte t ~addr ~data:hi;
    write_byte t ~addr:Uint16.(succ addr) ~data:lo
end
