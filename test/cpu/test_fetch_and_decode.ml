include Camlboy_lib
open Uints

module Mmu = Mock_mmu
module Fetch_and_decode = Fetch_and_decode.Make(Mmu)

let disassemble instr_bin_file out  =
  let rom_in = open_in instr_bin_file in
  let rom_len = in_channel_length rom_in in
  let rom_bytes = really_input_string rom_in rom_len |> Bytes.of_string in

  let mmu = Mmu.create ~size:0x3FF in
  Mmu.load mmu ~src:rom_bytes ~dst_pos:Uint16.zero;

  let rom_len = rom_len |> Uint16.of_int in
  let rec loop pc =
    if pc == rom_len then
      ()
    else
      let (inst_len, (cycle, cycle'), inst) = Fetch_and_decode.f mmu ~pc in
      Printf.fprintf out "{\n\tinst = %s;\n\tinst_len = %d;\n\tcycles = (%d, %d)\n}\n"
        (Instruction.show inst) (Uint16.to_int inst_len) cycle cycle';
      loop Uint16.(pc + inst_len)
  in

  loop Uint16.zero

let%expect_test "test all instructions" =
  disassemble "../resource/test_roms/all_instrs.bin" Stdio.stdout;

  [%expect {|
    {
    	inst = NOP;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = LD BC, 0xcdab;
    	inst_len = 3;
    	cycles = (3, 3)
    }
    {
    	inst = LD (BC), A;
    	inst_len = 1;
    	cycles = (2, 2)
    }
    {
    	inst = INC BC;
    	inst_len = 1;
    	cycles = (2, 2)
    }
    {
    	inst = INC B;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = DEC B;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = LD B, 0xab;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RLCA;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = LD (0x0a09), SP;
    	inst_len = 3;
    	cycles = (5, 5)
    }
    {
    	inst = DEC BC;
    	inst_len = 1;
    	cycles = (2, 2)
    }
    {
    	inst = INC C;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = DEC C;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = LD C, 0xab;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RRCA;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = STOP;
    	inst_len = 2;
    	cycles = (1, 1)
    }
    {
    	inst = LD DE, 0xcdab;
    	inst_len = 3;
    	cycles = (3, 3)
    }
    {
    	inst = LD (DE), A;
    	inst_len = 1;
    	cycles = (2, 2)
    }
    {
    	inst = INC DE;
    	inst_len = 1;
    	cycles = (2, 2)
    }
    {
    	inst = INC D;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = DEC D;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = LD D, 0xab;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RLA;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = JR -0x55;
    	inst_len = 2;
    	cycles = (3, 3)
    }
    {
    	inst = ADD HL, DE;
    	inst_len = 1;
    	cycles = (2, 2)
    }
    {
    	inst = LD A, (DE);
    	inst_len = 1;
    	cycles = (2, 2)
    }
    {
    	inst = DEC DE;
    	inst_len = 1;
    	cycles = (2, 2)
    }
    {
    	inst = INC E;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = DEC E;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = LD E, 0xab;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RRA;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = JR NZ, -0x55;
    	inst_len = 2;
    	cycles = (2, 3)
    }
    {
    	inst = LD HL, 0xcdab;
    	inst_len = 3;
    	cycles = (3, 3)
    }
    {
    	inst = LD (HL+), A;
    	inst_len = 1;
    	cycles = (2, 2)
    }
    {
    	inst = INC HL;
    	inst_len = 1;
    	cycles = (2, 2)
    }
    {
    	inst = INC H;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = DEC H;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = LD H, 0xab;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = DAA;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = JR Z, -0x55;
    	inst_len = 2;
    	cycles = (2, 3)
    }
    {
    	inst = ADD HL, HL;
    	inst_len = 1;
    	cycles = (2, 2)
    }
    {
    	inst = LD A, (HL+);
    	inst_len = 1;
    	cycles = (2, 2)
    }
    {
    	inst = DEC HL;
    	inst_len = 1;
    	cycles = (2, 2)
    }
    {
    	inst = INC L;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = DEC L;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = LD L, 0xab;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = CPL;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = JR NC, -0x55;
    	inst_len = 2;
    	cycles = (2, 3)
    }
    {
    	inst = LD SP, 0xcdab;
    	inst_len = 3;
    	cycles = (3, 3)
    }
    {
    	inst = LD (HL-), A;
    	inst_len = 1;
    	cycles = (2, 2)
    }
    {
    	inst = INC SP;
    	inst_len = 1;
    	cycles = (2, 2)
    }
    {
    	inst = INC (HL);
    	inst_len = 1;
    	cycles = (3, 3)
    }
    {
    	inst = DEC (HL);
    	inst_len = 1;
    	cycles = (3, 3)
    }
    {
    	inst = LD (HL), 0xab;
    	inst_len = 2;
    	cycles = (3, 3)
    }
    {
    	inst = SCF;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = JR C, -0x55;
    	inst_len = 2;
    	cycles = (2, 3)
    }
    {
    	inst = ADD HL, SP;
    	inst_len = 1;
    	cycles = (2, 2)
    }
    {
    	inst = LD A, (HL-);
    	inst_len = 1;
    	cycles = (2, 2)
    }
    {
    	inst = DEC SP;
    	inst_len = 1;
    	cycles = (2, 2)
    }
    {
    	inst = INC A;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = DEC A;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = LD A, 0xab;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = CCF;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = LD B, B;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = LD B, C;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = LD B, D;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = LD B, E;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = LD B, H;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = LD B, F;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = LD B, (HL);
    	inst_len = 1;
    	cycles = (2, 2)
    }
    {
    	inst = LD B, A;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = LD C, B;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = LD C, C;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = LD C, D;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = LD C, E;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = LD C, H;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = LD C, L;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = LD C, (HL);
    	inst_len = 1;
    	cycles = (2, 2)
    }
    {
    	inst = LD C, A;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = LD D, B;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = LD D, C;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = LD D, D;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = LD D, E;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = LD D, H;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = LD D, L;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = LD D, (HL);
    	inst_len = 1;
    	cycles = (2, 2)
    }
    {
    	inst = LD D, A;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = LD E, B;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = LD E, C;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = LD E, D;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = LD E, E;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = LD E, H;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = LD E, L;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = LD E, (HL);
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = LD E, A;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = LD H, B;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = LD H, C;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = LD H, D;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = LD H, E;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = LD H, H;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = LD H, L;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = LD H, (HL);
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = LD H, A;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = LD L, B;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = LD L, C;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = LD L, D;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = LD L, E;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = LD L, H;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = LD L, L;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = LD L, E;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = LD L, A;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = LD (HL), B;
    	inst_len = 1;
    	cycles = (2, 2)
    }
    {
    	inst = LD (HL), C;
    	inst_len = 1;
    	cycles = (2, 2)
    }
    {
    	inst = LD (HL), D;
    	inst_len = 1;
    	cycles = (2, 2)
    }
    {
    	inst = LD (HL), E;
    	inst_len = 1;
    	cycles = (2, 2)
    }
    {
    	inst = LD (HL), H;
    	inst_len = 1;
    	cycles = (2, 2)
    }
    {
    	inst = LD (HL), L;
    	inst_len = 1;
    	cycles = (2, 2)
    }
    {
    	inst = HALT;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = LD (HL), A;
    	inst_len = 1;
    	cycles = (2, 2)
    }
    {
    	inst = LD A, B;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = LD A, C;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = LD A, D;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = LD A, E;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = LD A, H;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = LD A, L;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = LD A, (HL);
    	inst_len = 1;
    	cycles = (2, 2)
    }
    {
    	inst = LD A, A;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = ADD A, B;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = ADD A, C;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = ADD A, D;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = ADD A, E;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = ADD A, H;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = ADD A, L;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = ADD A, (HL);
    	inst_len = 1;
    	cycles = (2, 2)
    }
    {
    	inst = ADD A, A;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = ADC A, B;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = ADC A, C;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = ADC A, D;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = ADC A, E;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = ADC A, H;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = ADC A, L;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = ADC A, (HL);
    	inst_len = 1;
    	cycles = (2, 2)
    }
    {
    	inst = ADC A, A;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = SUB A, B;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = SUB A, C;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = SUB A, D;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = SUB A, E;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = SUB A, H;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = SUB A, L;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = SUB A, (HL);
    	inst_len = 1;
    	cycles = (2, 2)
    }
    {
    	inst = SUB A, A;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = SBC A, B;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = SBC A, C;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = SBC A, D;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = SBC A, E;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = SBC A, H;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = SBC A, L;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = SBC A, (HL);
    	inst_len = 1;
    	cycles = (2, 2)
    }
    {
    	inst = SBC A, A;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = AND A, B;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = AND A, C;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = AND A, D;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = AND A, E;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = AND A, H;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = AND A, L;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = AND A, (HL);
    	inst_len = 1;
    	cycles = (2, 2)
    }
    {
    	inst = AND A, A;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = XOR A, B;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = XOR A, C;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = XOR A, D;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = XOR A, E;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = XOR A, H;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = XOR A, L;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = XOR A, (HL);
    	inst_len = 1;
    	cycles = (2, 2)
    }
    {
    	inst = XOR A, A;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = OR A, B;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = OR A, C;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = OR A, D;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = OR A, E;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = OR A, H;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = OR A, L;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = OR A, (HL);
    	inst_len = 1;
    	cycles = (2, 2)
    }
    {
    	inst = OR A, A;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = CP A, B;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = CP A, C;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = CP A, D;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = CP A, E;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = CP A, H;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = CP A, L;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = CP A, (HL);
    	inst_len = 1;
    	cycles = (2, 2)
    }
    {
    	inst = CP A, A;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = RET NZ;
    	inst_len = 1;
    	cycles = (2, 5)
    }
    {
    	inst = POP BC;
    	inst_len = 1;
    	cycles = (3, 3)
    }
    {
    	inst = JP NZ, 0xcdab;
    	inst_len = 3;
    	cycles = (3, 4)
    }
    {
    	inst = JP 0xcdab;
    	inst_len = 3;
    	cycles = (4, 4)
    }
    {
    	inst = CALL NZ, 0xcdab;
    	inst_len = 3;
    	cycles = (3, 6)
    }
    {
    	inst = PUSH BC;
    	inst_len = 1;
    	cycles = (1, 4)
    }
    {
    	inst = ADD A, 0xab;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RST 0x0000;
    	inst_len = 1;
    	cycles = (4, 4)
    }
    {
    	inst = RET Z;
    	inst_len = 1;
    	cycles = (2, 5)
    }
    {
    	inst = RET ;
    	inst_len = 1;
    	cycles = (4, 4)
    }
    {
    	inst = JP Z, 0xcdab;
    	inst_len = 3;
    	cycles = (3, 4)
    }
    {
    	inst = RLC B;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RLC C;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RLC D;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RLC E;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RLC H;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RLC L;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RLC (HL);
    	inst_len = 2;
    	cycles = (4, 4)
    }
    {
    	inst = RRC A;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RRC B;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RRC C;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RRC D;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RRC E;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RRC H;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RRC L;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RRC (HL);
    	inst_len = 2;
    	cycles = (4, 4)
    }
    {
    	inst = RRC A;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RL B;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RL C;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RL D;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RL E;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RL H;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RL L;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RL (HL);
    	inst_len = 2;
    	cycles = (4, 4)
    }
    {
    	inst = RR A;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RR B;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RR C;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RR D;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RR E;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RR H;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RR L;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RR (HL);
    	inst_len = 2;
    	cycles = (4, 4)
    }
    {
    	inst = RR A;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = SLA B;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = SLA C;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = SLA D;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = SLA E;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = SLA H;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = SLA L;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = SLA (HL);
    	inst_len = 2;
    	cycles = (4, 4)
    }
    {
    	inst = SRA A;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = SRA B;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = SRA C;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = SRA D;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = SRA E;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = SRA H;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = SRA L;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = SRA (HL);
    	inst_len = 2;
    	cycles = (4, 4)
    }
    {
    	inst = SRA A;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = SWAP B;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = SWAP C;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = SWAP D;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = SWAP E;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = SWAP H;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = SWAP L;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = SWAP (HL);
    	inst_len = 2;
    	cycles = (4, 4)
    }
    {
    	inst = SRL A;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = SRL B;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = SRL C;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = SRL D;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = SRL E;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = SRL H;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = SRL L;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = SRL (HL);
    	inst_len = 2;
    	cycles = (4, 4)
    }
    {
    	inst = SRL A;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = BIT 0x00, B;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = BIT 0x00, C;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = BIT 0x00, D;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = BIT 0x00, E;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = BIT 0x00, H;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = BIT 0x00, L;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = BIT 0x00, (HL);
    	inst_len = 2;
    	cycles = (4, 4)
    }
    {
    	inst = BIT 0x01, A;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = BIT 0x01, B;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = BIT 0x01, C;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = BIT 0x01, D;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = BIT 0x01, E;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = BIT 0x01, H;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = BIT 0x01, L;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = BIT 0x01, (HL);
    	inst_len = 2;
    	cycles = (4, 4)
    }
    {
    	inst = BIT 0x01, A;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = BIT 0x02, B;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = BIT 0x02, C;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = BIT 0x02, D;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = BIT 0x02, E;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = BIT 0x02, H;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = BIT 0x02, L;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = BIT 0x02, (HL);
    	inst_len = 2;
    	cycles = (4, 4)
    }
    {
    	inst = BIT 0x03, A;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = BIT 0x03, B;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = BIT 0x03, C;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = BIT 0x03, D;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = BIT 0x03, E;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = BIT 0x03, H;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = BIT 0x03, L;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = BIT 0x03, (HL);
    	inst_len = 2;
    	cycles = (4, 4)
    }
    {
    	inst = BIT 0x03, A;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = BIT 0x04, B;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = BIT 0x04, C;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = BIT 0x04, D;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = BIT 0x04, E;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = BIT 0x04, H;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = BIT 0x04, L;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = BIT 0x04, (HL);
    	inst_len = 2;
    	cycles = (4, 4)
    }
    {
    	inst = BIT 0x05, A;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = BIT 0x05, B;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = BIT 0x05, C;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = BIT 0x05, D;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = BIT 0x05, E;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = BIT 0x05, H;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = BIT 0x05, L;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = BIT 0x05, (HL);
    	inst_len = 2;
    	cycles = (4, 4)
    }
    {
    	inst = BIT 0x05, A;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = BIT 0x06, B;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = BIT 0x06, C;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = BIT 0x06, D;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = BIT 0x06, E;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = BIT 0x06, H;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = BIT 0x06, L;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = BIT 0x06, (HL);
    	inst_len = 2;
    	cycles = (4, 4)
    }
    {
    	inst = BIT 0x07, A;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = BIT 0x07, B;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = BIT 0x07, C;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = BIT 0x07, D;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = BIT 0x07, E;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = BIT 0x07, H;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = BIT 0x07, L;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = BIT 0x07, (HL);
    	inst_len = 2;
    	cycles = (4, 4)
    }
    {
    	inst = BIT 0x07, A;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RES 0x00, B;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RES 0x00, C;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RES 0x00, D;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RES 0x00, E;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RES 0x00, H;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RES 0x00, L;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RES 0x00, (HL);
    	inst_len = 2;
    	cycles = (4, 4)
    }
    {
    	inst = RES 0x01, A;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RES 0x01, B;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RES 0x01, C;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RES 0x01, D;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RES 0x01, E;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RES 0x01, H;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RES 0x01, L;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RES 0x01, (HL);
    	inst_len = 2;
    	cycles = (4, 4)
    }
    {
    	inst = RES 0x01, A;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RES 0x02, B;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RES 0x02, C;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RES 0x02, D;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RES 0x02, E;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RES 0x02, H;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RES 0x02, L;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RES 0x02, (HL);
    	inst_len = 2;
    	cycles = (4, 4)
    }
    {
    	inst = RES 0x03, A;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RES 0x03, B;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RES 0x03, C;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RES 0x03, D;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RES 0x03, E;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RES 0x03, H;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RES 0x03, L;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RES 0x03, (HL);
    	inst_len = 2;
    	cycles = (4, 4)
    }
    {
    	inst = RES 0x03, A;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RES 0x04, B;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RES 0x04, C;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RES 0x04, D;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RES 0x04, E;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RES 0x04, H;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RES 0x04, L;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RES 0x04, (HL);
    	inst_len = 2;
    	cycles = (4, 4)
    }
    {
    	inst = RES 0x05, A;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RES 0x05, B;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RES 0x05, C;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RES 0x05, D;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RES 0x05, E;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RES 0x05, H;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RES 0x05, L;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RES 0x05, (HL);
    	inst_len = 2;
    	cycles = (4, 4)
    }
    {
    	inst = RES 0x05, A;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RES 0x06, B;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RES 0x06, C;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RES 0x06, D;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RES 0x06, E;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RES 0x06, H;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RES 0x06, L;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RES 0x06, (HL);
    	inst_len = 2;
    	cycles = (4, 4)
    }
    {
    	inst = RES 0x07, A;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RES 0x07, B;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RES 0x07, C;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RES 0x07, D;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RES 0x07, E;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RES 0x07, H;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RES 0x07, L;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RES 0x07, (HL);
    	inst_len = 2;
    	cycles = (4, 4)
    }
    {
    	inst = RES 0x07, A;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = SET 0x00, B;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = SET 0x00, C;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = SET 0x00, D;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = SET 0x00, E;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = SET 0x00, H;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = SET 0x00, L;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = SET 0x00, (HL);
    	inst_len = 2;
    	cycles = (4, 4)
    }
    {
    	inst = SET 0x01, A;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = SET 0x01, B;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = SET 0x01, C;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = SET 0x01, D;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = SET 0x01, E;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = SET 0x01, H;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = SET 0x01, L;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = SET 0x01, (HL);
    	inst_len = 2;
    	cycles = (4, 4)
    }
    {
    	inst = SET 0x01, A;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = SET 0x02, B;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = SET 0x02, C;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = SET 0x02, D;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = SET 0x02, E;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = SET 0x02, H;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = SET 0x02, L;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = SET 0x02, (HL);
    	inst_len = 2;
    	cycles = (4, 4)
    }
    {
    	inst = SET 0x03, A;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = SET 0x03, B;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = SET 0x03, C;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = SET 0x03, D;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = SET 0x03, E;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = SET 0x03, H;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = SET 0x03, L;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = SET 0x03, (HL);
    	inst_len = 2;
    	cycles = (4, 4)
    }
    {
    	inst = SET 0x03, A;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = SET 0x04, B;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = SET 0x04, C;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = SET 0x04, D;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = SET 0x04, E;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = SET 0x04, H;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = SET 0x04, L;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = SET 0x04, (HL);
    	inst_len = 2;
    	cycles = (4, 4)
    }
    {
    	inst = SET 0x05, A;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = SET 0x05, B;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = SET 0x05, C;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = SET 0x05, D;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = SET 0x05, E;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = SET 0x05, H;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = SET 0x05, L;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = SET 0x05, (HL);
    	inst_len = 2;
    	cycles = (4, 4)
    }
    {
    	inst = SET 0x05, A;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = SET 0x06, B;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = SET 0x06, C;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = SET 0x06, D;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = SET 0x06, E;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = SET 0x06, H;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = SET 0x06, L;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = SET 0x06, (HL);
    	inst_len = 2;
    	cycles = (4, 4)
    }
    {
    	inst = SET 0x07, A;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = SET 0x07, B;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = SET 0x07, C;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = SET 0x07, D;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = SET 0x07, E;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = SET 0x07, H;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = SET 0x07, L;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = SET 0x07, (HL);
    	inst_len = 2;
    	cycles = (4, 4)
    }
    {
    	inst = SET 0x07, A;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = CALL Z, 0xcdab;
    	inst_len = 3;
    	cycles = (3, 6)
    }
    {
    	inst = CALL 0xcdab;
    	inst_len = 3;
    	cycles = (6, 6)
    }
    {
    	inst = ADC A, 0xab;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RST 0x0008;
    	inst_len = 1;
    	cycles = (4, 4)
    }
    {
    	inst = RET NC;
    	inst_len = 1;
    	cycles = (2, 5)
    }
    {
    	inst = POP DE;
    	inst_len = 1;
    	cycles = (3, 3)
    }
    {
    	inst = JP NC, 0xcdab;
    	inst_len = 3;
    	cycles = (3, 4)
    }
    {
    	inst = NOP;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = CALL NC, 0xcdab;
    	inst_len = 3;
    	cycles = (3, 6)
    }
    {
    	inst = PUSH DE;
    	inst_len = 1;
    	cycles = (1, 4)
    }
    {
    	inst = SUB A, 0xab;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RST 0x0010;
    	inst_len = 1;
    	cycles = (4, 4)
    }
    {
    	inst = RET C;
    	inst_len = 1;
    	cycles = (2, 5)
    }
    {
    	inst = RETI;
    	inst_len = 1;
    	cycles = (4, 4)
    }
    {
    	inst = JP C, 0xcdab;
    	inst_len = 3;
    	cycles = (3, 4)
    }
    {
    	inst = NOP;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = CALL C, 0xcdab;
    	inst_len = 3;
    	cycles = (3, 6)
    }
    {
    	inst = NOP;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = SBC A, 0xab;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RST 0x0018;
    	inst_len = 1;
    	cycles = (4, 4)
    }
    {
    	inst = LD (0xFF00+0xab), A;
    	inst_len = 2;
    	cycles = (3, 3)
    }
    {
    	inst = POP HL;
    	inst_len = 1;
    	cycles = (3, 3)
    }
    {
    	inst = LD (0xFF00+C), A;
    	inst_len = 1;
    	cycles = (2, 2)
    }
    {
    	inst = NOP;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = NOP;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = PUSH HL;
    	inst_len = 1;
    	cycles = (4, 4)
    }
    {
    	inst = AND A, 0xab;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RST 0x0020;
    	inst_len = 1;
    	cycles = (4, 4)
    }
    {
    	inst = ADD SP, 0xab;
    	inst_len = 2;
    	cycles = (4, 4)
    }
    {
    	inst = JP HL;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = LD (0xcdab), A;
    	inst_len = 3;
    	cycles = (4, 4)
    }
    {
    	inst = NOP;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = NOP;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = NOP;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = XOR A, 0xab;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RST 0x0028;
    	inst_len = 1;
    	cycles = (4, 4)
    }
    {
    	inst = LD A, (0xFF00+0xab);
    	inst_len = 2;
    	cycles = (3, 3)
    }
    {
    	inst = POP AF;
    	inst_len = 1;
    	cycles = (3, 3)
    }
    {
    	inst = LD A, (0xFF00+C);
    	inst_len = 1;
    	cycles = (2, 2)
    }
    {
    	inst = DI;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = NOP;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = PUSH AF;
    	inst_len = 1;
    	cycles = (4, 4)
    }
    {
    	inst = OR A, 0xab;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RST 0x0030;
    	inst_len = 1;
    	cycles = (4, 4)
    }
    {
    	inst = LD HL, SP+0xab;
    	inst_len = 2;
    	cycles = (3, 3)
    }
    {
    	inst = LD SP, HL;
    	inst_len = 1;
    	cycles = (2, 2)
    }
    {
    	inst = LD A, (0xcdab);
    	inst_len = 3;
    	cycles = (4, 4)
    }
    {
    	inst = EI;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = NOP;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = NOP;
    	inst_len = 1;
    	cycles = (1, 1)
    }
    {
    	inst = CP A, 0xab;
    	inst_len = 2;
    	cycles = (2, 2)
    }
    {
    	inst = RST 0x0038;
    	inst_len = 1;
    	cycles = (4, 4)
    } |}]

(* let gen_all_instrs () =
 *   let hi x = (x land 0xF0) lsr 4 in
 *   let lo x = (x land 0x0F) in
 *   let out = open_out "../resource/test_roms/all_instrs.bin" in
 *   for i = 0 to 0xFF do
 *     if i = 0xCB then begin
 *       for j = 0 to 0xFF do
 *         output_byte out i;
 *         output_byte out j
 *       done
 *     end
 *     else begin
 *       output_byte out i;
 *       begin match (lo i), (hi i) with
 *         | 0, 1 | 0, 2 | 0, 3 | 0, 0xE | 0, 0xF
 *         | 6, 0x0 | 6, 1 | 6, 2 | 6, 3 | 6, 0xC | 6, 0xD | 6, 0xE | 6, 0xF
 *         | 8, 1 | 8, 2 | 8, 3 | 8, 0xE | 8, 0xF
 *         | 0xE, 0 | 0xE, 1 | 0xE, 2 | 0xE, 3 | 0xE, 0xE | 0xE, 0xC | 0xE, 0xD | 0xE, 0xF
 *           -> output_byte out 0xAB
 *         | 1, 0 | 1, 1 | 1, 2 | 1, 3
 *         | 2, 0xC | 2, 0xD
 *         | 3, 0xC
 *         | 4, 0xC | 4, 0xD
 *         | 0xA, 0xC | 0xA, 0xD | 0xA, 0xE | 0xA, 0xF
 *         | 0xC, 0xC | 0xC, 0xD
 *         | 0xD, 0xC
 *           ->
 *           output_byte out 0xAB;
 *           output_byte out 0xCD
 *         | _ -> ()
 *       end;
 *       if i = 0xCB then begin
 *         for j = 0 to 0xFF do
 *           output_byte out j
 *         done
 *       end
 *     end
 *   done;
 *   flush out *)
