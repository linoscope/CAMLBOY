open Uints

module Mmu = struct

  type t = {
    rom_bank_0 : Rom.t;
    wram       : Ram.t;
    shadow_ram : Shadow_ram.t;
    gpu        : Gpu.t;
    zero_page  : Ram.t;
    serial_port : Serial_port.t;
    ic : Interrupt_controller.t;
  }

  let create ~rom ~wram ~gpu ~zero_page ~shadow_ram ~serial_port ~ic = {
    rom_bank_0 = rom;
    wram;
    shadow_ram;
    gpu;
    zero_page;
    serial_port;
    ic;
  }

  let read_byte t addr =
    match addr with
    | _ when Rom.accepts t.rom_bank_0 ~addr        -> Rom.read_byte t.rom_bank_0 addr
    | _ when Ram.accepts t.wram       ~addr        -> Ram.read_byte t.wram addr
    | _ when Gpu.accepts t.gpu        ~addr        -> Gpu.read_byte t.gpu addr
    | _ when Ram.accepts t.zero_page  ~addr        -> Ram.read_byte t.zero_page addr
    | _ when Shadow_ram.accepts t.shadow_ram ~addr -> Shadow_ram.read_byte t.shadow_ram addr
    | _ when Serial_port.accepts t.serial_port ~addr -> Serial_port.read_byte t.serial_port addr
    | _ when Interrupt_controller.accepts t.ic ~addr -> Interrupt_controller.read_byte t.ic addr
    | _ -> Uint8.zero
  (* raise @@ Invalid_argument (Printf.sprintf "Address out of range: %s" (Uint16.show addr)) *)


  let write_byte t ~(addr : uint16) ~(data : uint8) =
    match addr with
    | _ when Rom.accepts t.rom_bank_0 ~addr        -> Rom.write_byte t.rom_bank_0 ~addr ~data
    | _ when Ram.accepts t.wram       ~addr        -> Ram.write_byte t.wram ~addr ~data
    | _ when Gpu.accepts t.gpu        ~addr        -> Gpu.write_byte t.gpu ~addr ~data
    | _ when Ram.accepts t.zero_page  ~addr        -> Ram.write_byte t.zero_page ~addr ~data
    | _ when Shadow_ram.accepts t.shadow_ram ~addr -> Shadow_ram.write_byte t.shadow_ram ~addr ~data
    | _ when Serial_port.accepts t.serial_port ~addr -> Serial_port.write_byte t.serial_port ~addr ~data
    | _ when Interrupt_controller.accepts t.ic ~addr -> Interrupt_controller.write_byte t.ic ~addr ~data
    | _ -> ()
  (* raise @@ Invalid_argument (Printf.sprintf "Address out of range: %s" (Uint16.show addr)) *)

  let accepts t ~addr =
    Rom.accepts t.rom_bank_0 ~addr
    || Ram.accepts t.wram ~addr
    || Gpu.accepts t.gpu ~addr
    || Ram.accepts t.zero_page ~addr
    || Shadow_ram.accepts t.shadow_ram ~addr
    || Shadow_ram.accepts t.shadow_ram ~addr
    || Serial_port.accepts t.serial_port ~addr
    || Interrupt_controller.accepts t.ic ~addr

end

include Mmu
include Word_addressable.Make (Mmu)
