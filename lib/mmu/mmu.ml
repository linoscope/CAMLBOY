open Uints
module Bytes = BytesLabels
open StdLabels

module Make (Gpu : Addressable_intf.S) = struct

  type t = {
    rom_bank_0 : bytes;
    ram : Ram.t;
    gpu : Gpu.t;
    zero_page : Ram.t;
  }

  type region =
    | Rom_bank_0
    | Ram
    | Shadow_ram
    | Gpu_region
    | Zero_page

  let region_of_addr addr =
    match Uint16.to_int addr with
    | addr when 0x0000 <= addr && addr <= 0x3FFF -> Rom_bank_0
    | addr when 0xC000 <= addr && addr <= 0xDFFF -> Ram
    | addr when 0xE000 <= addr && addr <= 0xFDFF -> Shadow_ram
    | addr when 0x8000 <= addr && addr <= 0x9FFF -> Gpu_region
    | addr when 0xFF80 <= addr && addr <= 0xFFFF -> Zero_page
    | addr -> failwith @@ Printf.sprintf "Unmapped address : 0x%04x"  addr

  let create ~gpu = {
    rom_bank_0 = Bytes.create (0x3FFF - 0x0000);
    ram = Ram.create ~start_addr:(Uint16.of_int 0xC000) ~end_addr:(Uint16.of_int 0xDFFF);
    gpu;
    zero_page = Ram.create ~start_addr:(Uint16.of_int 0xFF80) ~end_addr:(Uint16.of_int 0xFFFF);
  }

  let load_rom t ~rom  =
    Bytes.blit ~src:rom ~src_pos:0 ~dst:t.rom_bank_0 ~dst_pos:0 ~len:(Bytes.length rom)

  let read_byte t addr =
    match region_of_addr addr with
    | Rom_bank_0 -> Bytes.get_int8 t.rom_bank_0 (Uint16.to_int addr) |> Uint8.of_int
    | Ram
    | Shadow_ram -> Ram.read_byte t.ram addr
    | Gpu_region -> Gpu.read_byte t.gpu addr
    | Zero_page  -> Ram.read_byte t.zero_page addr


  let write_byte t ~(addr : uint16) ~(data : uint8) =
    match region_of_addr addr with
    | Rom_bank_0 -> Bytes.set_int8 t.rom_bank_0 (Uint16.to_int addr) (Uint8.to_int data)
    | Ram
    | Shadow_ram -> Ram.write_byte t.ram ~addr ~data
    | Gpu_region -> Gpu.write_byte t.gpu ~addr ~data
    | Zero_page  -> Ram.write_byte t.zero_page ~addr ~data

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
