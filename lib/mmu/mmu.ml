open Uints

module Make (Gpu : Addressable_intf.S) = struct

  type t = {
    rom_bank_0 : Rom.t;
    wram : Ram.t;
    shadow_ram : Shadow_ram.t;
    gpu : Gpu.t;
    zero_page : Ram.t;
  }

  let create ~rom ~wram ~gpu ~zero_page ~shadow_ram = {
    rom_bank_0 = rom;
    wram;
    shadow_ram;
    gpu;
    zero_page;
  }

  let read_byte t addr =
    match addr with
    | _ when Rom.accepts t.rom_bank_0 ~addr -> Rom.read_byte t.rom_bank_0 addr
    | _ when Ram.accepts t.wram       ~addr -> Ram.read_byte t.wram addr
    | _ when Gpu.accepts t.gpu        ~addr -> Gpu.read_byte t.gpu addr
    | _ when Ram.accepts t.zero_page  ~addr -> Ram.read_byte t.zero_page addr
    | _ -> raise @@ Invalid_argument (Printf.sprintf "Address out of range: %s" (Uint16.show addr))


  let write_byte t ~(addr : uint16) ~(data : uint8) =
    match addr with
    | _ when Rom.accepts t.rom_bank_0 ~addr -> Rom.write_byte t.rom_bank_0 ~addr ~data
    | _ when Ram.accepts t.wram       ~addr -> Ram.write_byte t.wram ~addr ~data
    | _ when Gpu.accepts t.gpu        ~addr -> Gpu.write_byte t.gpu ~addr ~data
    | _ when Ram.accepts t.zero_page  ~addr -> Ram.write_byte t.zero_page ~addr ~data
    | _ -> raise @@ Invalid_argument (Printf.sprintf "Address out of range: %s" (Uint16.show addr))

  let read_word t addr =
    Uint8.(read_byte t addr + read_byte t Uint16.(succ addr) lsl 8)
    |> Uint16.of_uint8

  let write_word t ~addr ~(data : uint16) =
    let data = Uint16.to_int data in
    let hi = data lsr 8 |> Uint8.of_int in
    let lo = data land 0xF |> Uint8.of_int in
    write_byte t ~addr ~data:hi;
    write_byte t ~addr:Uint16.(succ addr) ~data:lo

  let accepts t ~addr =
    Rom.accepts t.rom_bank_0 ~addr
    || Ram.accepts t.wram ~addr
    || Gpu.accepts t.gpu ~addr
    || Ram.accepts t.zero_page ~addr

end
