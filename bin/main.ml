open Camlboy_lib
open Uints

let () =
  let mmu = Mmu.create ~size:0xFFFF in
  Mmu.load mmu ~src:Bios.bytes ~dst_pos:Uint16.zero;
  let cpu = Cpu.create mmu in

  while true do
    Cpu.tick cpu;
  done
