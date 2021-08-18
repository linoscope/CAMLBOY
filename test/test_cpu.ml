open Camlboy_lib
open Ints

let create_cpu () =
  let registers = Registers.create () in
  Registers.write_r registers A (Uint8.of_int 0xAA);
  Registers.write_r registers B (Uint8.of_int 0xBB);
  Registers.write_r registers C (Uint8.of_int 0xCC);
  Registers.write_r registers D (Uint8.of_int 0xDD);
  Registers.write_r registers E (Uint8.of_int 0xEE);
  Registers.write_r registers F (Uint8.of_int 0x00);
  Registers.write_r registers H (Uint8.of_int 0x00);
  Registers.write_r registers L (Uint8.of_int 0x02);
  let mmu = Mmu.create ~size:0x10 in
  let zeros = Bytes.create 0x10 in
  Bytes.fill zeros 0 0x10 (Char.chr 0);
  Mmu.load mmu ~src:zeros ~dst_pos:Uint16.zero;
  Cpu.For_tests.create
    ~mmu
    ~registers
    ~pc:Uint16.zero
    ~sp:Uint16.(of_int 0xFF)

let print_inst_result inst =
  let t = create_cpu () in

  inst
  |> Cpu.For_tests.execute t (Uint16.of_int 2);
  Cpu.show t
  |> print_endline


let%expect_test "LD B, 0xAB" =
  LD (R B, Immediate (Uint8.of_int 0x99))
  |> print_inst_result;

  [%expect {|
    { Cpu.registers =
      { Registers.a = 0xaa; b = 0x99; c = 0xcc; d = 0xdd; e = 0xee;
        f = (c=0, h=0, n=0, z=0); h = 0x00; l = 0x02 };
      pc = 0x0002; sp = 0x00ff;
      mmu = 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  } |}]

let%expect_test "LD (BC), 0x9988" =
  LD16 (RR BC, Immediate (Uint16.of_int 0x9988))
  |> print_inst_result;

  [%expect {|
    { Cpu.registers =
      { Registers.a = 0xaa; b = 0x99; c = 0x88; d = 0xdd; e = 0xee;
        f = (c=0, h=0, n=0, z=0); h = 0x00; l = 0x02 };
      pc = 0x0002; sp = 0x00ff;
      mmu = 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  } |}]

let%expect_test "LD (HL), B" =
  LD (RR_indirect HL, R B)
  |> print_inst_result;

  [%expect{|
    { Cpu.registers =
      { Registers.a = 0xaa; b = 0xbb; c = 0xcc; d = 0xdd; e = 0xee;
        f = (c=0, h=0, n=0, z=0); h = 0x00; l = 0x02 };
      pc = 0x0002; sp = 0x00ff;
      mmu = 00 00 bb 00 00 00 00 00 00 00 00 00 00 00 00 00  } |}]
