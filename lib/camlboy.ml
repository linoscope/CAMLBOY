open Uints

module Cpu = Cpu.Make(Mmu)

type t = { cpu: Cpu.t }

let create () =
  let open Uint16 in
  let rom = Rom.create
      ~start_addr:(of_int 0x0000)
      ~end_addr:(of_int 0x3FFF)
  in
  Rom.load rom ~rom_bytes:Bios.bytes;
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
      ~end_addr:(of_int 0xFFFF)
  in
  let gpu = Gpu.create
      ~vram:(Ram.create ~start_addr:(of_int 0x8000) ~end_addr:(of_int 0xFE9F))
      ~oam:(Ram.create  ~start_addr:(of_int 0xFF00) ~end_addr:(of_int 0xFF7F))
      ~bgp:(Mmap_register.create ~addr:(of_int 0xFF47) ~type_:`RW ())
  in
  let mmu = Mmu.create
      ~rom
      ~wram
      ~shadow_ram
      ~zero_page
      ~gpu
  in
  let cpu = Cpu.create mmu in
  { cpu }

let tick t =
  ignore (Cpu.tick t.cpu : int)
