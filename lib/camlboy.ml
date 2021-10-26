open Uints

module Make (Cartridge : Cartridge_intf.S) = struct

  module Mmu = Mmu.Make(Cartridge)

  module Cpu = Cpu.Make(Mmu)

  type t = {
    cpu    : Cpu.t;
    timer  : Timer.t;  [@opaque]
    gpu    : Gpu.t;    [@opaque]
    joypad : Joypad.t; [@opaque]
  } [@@deriving show]

  let show t = Cpu.show t.cpu

  let initialize_state ~registers ~mmu ~lcd_stat ~gpu =
    (* initialize registers *)
    Registers.set_flags registers ~z:true ~n:false ~h:true ~c:true ();
    Registers.[
      (AF, 0x01B0);
      (BC, 0x0013);
      (DE, 0x00D8);
      (HL, 0x014D)
    ]
    |> List.iter (fun (reg, data) ->
        Registers.write_rr registers reg (Uint16.of_int data));

    (* initialize mmu *)
    [
      (0xFF00, 0xCF);
      (0xFF01, 0x00);
      (0xFF02, 0x7E);
      (0xFF04, 0xAB);
      (0xFF05, 0x00);
      (0xFF06, 0x00);
      (0xFF07, 0xF8);
      (0xFF0F, 0xE1);
      (* TODO: Fill sound related IO registers *)
      (* (0xFF10, 0x--); *)
      (0xFF40, 0x91);
      (0xFF42, 0x00);
      (0xFF43, 0x00);
      (0xFF44, 0x00);
      (0xFF45, 0x00);
      (0xFF46, 0xFF);
      (0xFF47, 0xFC);
      (0xFF4A, 0x00);
      (0xFF4B, 0x00);
      (* (0xFF4D, 0x--); *)
      (0xFFFF, 0x00);
    ]
    |> List.iter (fun (addr, data) ->
        Mmu.write_byte mmu ~addr:(Uint16.of_int addr) ~data:(Uint8.of_int data));

    (* initialize GPU *)
    Lcd_stat.set_gpu_mode lcd_stat Gpu_mode.VBlank;
    Gpu.set_mcycles_in_mode gpu 0


  let ly_addr = Uint16.of_int 0xFF44

  let lcd_stat_addr = Uint16.of_int 0xFF41

  let create_with_rom ~print_serial_port ~(rom_bytes : Bigstringaf.t) =
    let open Uint16 in
    let cartridge = Cartridge.create ~rom_bytes
    in
    let wram = Ram.create
        ~start_addr:(of_int 0xC000)
        ~end_addr:(of_int 0xDFFF)
    in
    let shadow_ram = Shadow_ram.create
        ~target:wram
        ~target_start:(of_int 0xC000)
        ~shadow_start:(of_int 0xE000)
        ~shadow_end:(of_int 0xFDFF)
    in
    let zero_page = Ram.create
        ~start_addr:(of_int 0xFF80)
        ~end_addr:(of_int 0xFFFE)
    in
    let serial_port = Serial_port.create
        ~sb:(Mmap_register.create ~addr:(of_int 0xFF01) ~type_:`RW ())
        ~sc:(Mmap_register.create ~addr:(of_int 0xFF02) ~type_:`RW ())
        ~print_serial_port
        ()
    in
    let ic = Interrupt_controller.create
        ~ie_addr:(of_int 0xFFFF)
        ~if_addr:(of_int 0xFF0F)
    in
    let tile_data = Tile_data.create
        ~start_addr:(of_int 0x8000)
        ~end_addr:(of_int 0x97FF)
    in
    let tile_map = Tile_map.create
        ~tile_map_ram:(Ram.create ~start_addr:(Uint16.of_int 0x9800) ~end_addr:(Uint16.of_int 0x9FFF))
        ~area0_start_addr:(Uint16.of_int 0x9800)
        ~area1_start_addr:(Uint16.of_int 0x9C00)
    in
    let oam_table = Oam_table.create
        ~start_addr:(of_int 0xFE00)
        ~end_addr:(of_int 0xFE9F)
    in
    let lcd_stat = Lcd_stat.create ~addr:lcd_stat_addr in
    let joypad = Joypad.create
        ~addr:(of_int 0xFF00)
        ~ic
    in
    let gpu = Gpu.create
        ~tile_data
        ~tile_map
        ~oam:oam_table
        ~bgp:(Pallete.create ~addr:(of_int 0xFF47))
        ~obp0:(Pallete.create ~addr:(of_int 0xFF48))
        ~obp1:(Pallete.create ~addr:(of_int 0xFF49))
        ~lcd_control:(Lcd_control.create ~addr:(of_int 0xFF40))
        ~lcd_stat
        ~lcd_position:(
          Lcd_position.create
            ~scy_addr:(of_int 0xFF42)
            ~scx_addr:(of_int 0xFF43)
            ~ly_addr
            ~lyc_addr:(of_int 0xFF45)
            ~wy_addr:(of_int 0xFF4A)
            ~wx_addr:(of_int 0xFF4B))
        ~ic
    in
    let timer = Timer.create
        ~div_addr:(of_int 0xFF04)
        ~tima_addr:(of_int 0xFF05)
        ~tma_addr:(of_int 0xFF06)
        ~tac_addr:(of_int 0xFF07)
        ~ic
    in
    let dma_transfer = Mmap_register.create
        ~addr:(of_int 0xFF46)
        ~type_:`RW
        ()
    in
    let mmu = Mmu.create
        ~cartridge
        ~wram
        ~shadow_ram
        ~zero_page
        ~gpu
        ~joypad
        ~serial_port
        ~ic
        ~timer
        ~dma_transfer
    in
    let registers = Registers.create () in
    let cpu = Cpu.create
        ~mmu
        ~ic
        ~registers
        ~sp:(of_int 0xFFFE)
        ~pc:(of_int 0x0100)
        ~halted:false
        ~ime:false
    in
    initialize_state ~mmu ~registers ~lcd_stat ~gpu;
    { cpu; timer; gpu; joypad }

  let run_instruction t =
    let mcycles = Cpu.run_instruction t.cpu in
    Timer.run t.timer ~mcycles;
    Gpu.run t.gpu ~mcycles

  let press t key = Joypad.press t.joypad key

  let release t key = Joypad.release t.joypad key


  module For_tests = struct

    let prev_inst t = Cpu.For_tests.prev_inst t.cpu

    let get_ly t = Gpu.read_byte t.gpu ly_addr |> Uint8.to_int

    let get_lcd_stat t = Gpu.read_byte t.gpu lcd_stat_addr

    let get_mcycles_in_mode t = Gpu.For_tests.get_mcycles_in_mode t.gpu

    let get_tima_count t = Timer.For_tests.get_tima_count t.timer

  end

end
