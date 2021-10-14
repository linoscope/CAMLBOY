open Uints

module Make (Cartridge : Addressable_intf.S) = struct

  type t = {
    cartridge   : Cartridge.t;
    wram        : Ram.t;
    shadow_ram  : Shadow_ram.t;
    gpu         : Gpu.t;
    zero_page   : Ram.t;
    joypad      : Joypad.t;
    serial_port : Serial_port.t;
    ic          : Interrupt_controller.t;
    timer       : Timer.t;
  }

  let create ~cartridge ~wram ~gpu ~zero_page ~shadow_ram ~joypad ~serial_port ~ic ~timer = {
    cartridge = cartridge;
    wram;
    shadow_ram;
    gpu;
    zero_page;
    joypad;
    serial_port;
    ic;
    timer;
  }

  let read_byte t addr =
    match addr with
    | _ when Cartridge.accepts t.cartridge addr     -> Cartridge.read_byte t.cartridge addr
    | _ when Ram.accepts t.wram       addr          -> Ram.read_byte t.wram addr
    | _ when Gpu.accepts t.gpu        addr          -> Gpu.read_byte t.gpu addr
    | _ when Ram.accepts t.zero_page  addr          -> Ram.read_byte t.zero_page addr
    | _ when Shadow_ram.accepts t.shadow_ram addr   -> Shadow_ram.read_byte t.shadow_ram addr
    | _ when Joypad.accepts t.joypad addr           -> Joypad.read_byte t.joypad addr
    | _ when Serial_port.accepts t.serial_port addr -> Serial_port.read_byte t.serial_port addr
    | _ when Interrupt_controller.accepts t.ic addr -> Interrupt_controller.read_byte t.ic addr
    | _ when Timer.accepts t.timer addr             -> Timer.read_byte t.timer addr
    | _ -> Uint8.zero


  let write_byte t ~(addr : uint16) ~(data : uint8) =
    match addr with
    | _ when Cartridge.accepts t.cartridge addr     -> Cartridge.write_byte t.cartridge ~addr ~data
    | _ when Ram.accepts t.wram       addr          -> Ram.write_byte t.wram ~addr ~data
    | _ when Gpu.accepts t.gpu        addr          -> Gpu.write_byte t.gpu ~addr ~data
    | _ when Ram.accepts t.zero_page  addr          -> Ram.write_byte t.zero_page ~addr ~data
    | _ when Shadow_ram.accepts t.shadow_ram addr   -> Shadow_ram.write_byte t.shadow_ram ~addr ~data
    | _ when Joypad.accepts t.joypad addr           -> Joypad.write_byte t.joypad ~addr ~data
    | _ when Serial_port.accepts t.serial_port addr -> Serial_port.write_byte t.serial_port ~addr ~data
    | _ when Interrupt_controller.accepts t.ic addr -> Interrupt_controller.write_byte t.ic ~addr ~data
    | _ when Timer.accepts t.timer  addr            -> Timer.write_byte t.timer ~addr ~data
    | _ -> ()

  let accepts t addr =
    Cartridge.accepts t.cartridge addr
    || Ram.accepts t.wram addr
    || Gpu.accepts t.gpu addr
    || Ram.accepts t.zero_page addr
    || Shadow_ram.accepts t.shadow_ram addr
    || Shadow_ram.accepts t.shadow_ram addr
    || Joypad.accepts t.joypad addr
    || Serial_port.accepts t.serial_port addr
    || Interrupt_controller.accepts t.ic addr
    || Timer.accepts t.timer addr


  let read_word t addr =
    let lo = Uint8.to_int (read_byte t addr) in
    let hi = Uint8.to_int (read_byte t Uint16.(succ addr)) in
    (hi lsl 8) + lo |> Uint16.of_int

  let write_word t ~addr ~(data : uint16) =
    let data = Uint16.to_int data in
    let hi = data lsr 8 |> Uint8.of_int in
    let lo = data land 0xFF |> Uint8.of_int in
    write_byte t ~addr ~data:lo;
    write_byte t ~addr:Uint16.(succ addr) ~data:hi

end
