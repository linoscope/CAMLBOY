open Uints

module Cpu = Cpu.Make(Mmu)

type t = {
  cpu: Cpu.t;
} [@@deriving show]

let show t = Cpu.show t.cpu

let create_with_rom ~echo_flag ~rom_bytes =
  let open Uint16 in
  let rom = Rom.create
      ~start_addr:(of_int 0x0000)
      ~end_addr:(of_int 0x7FFF)
  in
  Rom.load rom ~rom_bytes;
  let wram = Ram.create
      ~start_addr:(of_int 0xC000)
      ~end_addr:(of_int 0xDFFF) in
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
  let gpu = Gpu.create
      ~vram:(Ram.create ~start_addr:(of_int 0x8000) ~end_addr:(of_int 0x9FFF))
      ~oam:(Ram.create  ~start_addr:(of_int 0xFE00) ~end_addr:(of_int 0xFE9F))
      ~bgp:(Mmap_register.create ~addr:(of_int 0xFF47) ~type_:`RW ())
  in
  let serial_port = Serial_port.create
      ~sb:(Mmap_register.create ~addr:(of_int 0xFF01) ~type_:`RW ())
      ~sc:(Mmap_register.create ~addr:(of_int 0xFF02) ~type_:`RW ())
      ~echo_flag
      ()
  in
  let mmu = Mmu.create
      ~rom
      ~wram
      ~shadow_ram
      ~zero_page
      ~gpu
      ~serial_port
  in
  let registers = Registers.create () in
  Registers.write_rr registers AF (of_int 0x01b0);
  Registers.write_rr registers BC (of_int 0x0013);
  Registers.write_rr registers DE (of_int 0x00D8);
  Registers.write_rr registers HL (of_int 0x014D);
  Registers.set_flags registers ~z:true ~n:false ~h:true ~c:true ();
  let cpu =
    Cpu.For_tests.create
      ~mmu
      ~registers
      ~sp:(of_int 0xFFFE)
      ~pc:(of_int 0x0100)
      ~halted:false
      ~ime:false
  in
  { cpu }

let create ~echo_flag = create_with_rom ~rom_bytes:Bios.bytes ~echo_flag

let tick t =
  ignore (Cpu.tick t.cpu : int)

module For_tests = struct

  let prev_inst t = Cpu.For_tests.prev_inst t.cpu

  let current_pc t = Cpu.For_tests.current_pc t.cpu

end
