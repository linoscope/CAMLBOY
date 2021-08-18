include Camlboy_lib
open Ints

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
      let (inst_len, inst) = Instruction.fetch_and_decode mmu ~pc in
      Instruction.show inst |> Printf.fprintf out "%s\n";
      loop Uint16.(pc + inst_len)
  in

  loop Uint16.zero

let%expect_test "test all instructions" =
  disassemble "../resource/test_roms/all_instrs.bin" Stdio.stdout;

  [%expect {|
    NOP
    LD BC, 0xcdab
    LD (BC), A
    INC BC
    INC B
    DEC B
    LD B, 0xab
    RLCA
    LD (0x0a09), SP
    DEC BC
    INC C
    DEC C
    LD C, 0xab
    RRCA
    STOP
    LD DE, 0xcdab
    LD (DE), A
    INC DE
    INC D
    DEC D
    LD D, 0xab
    RLA
    JR 0xab
    ADD HL, DE
    LD A, (DE)
    DEC DE
    INC E
    DEC E
    LD E, 0xab
    RRA
    JR NZ, 0xab
    LD HL, 0xcdab
    LD (HL+), A
    INC HL
    INC H
    DEC H
    LD H, 0xab
    DAA
    JR Z, 0xab
    ADD HL, HL
    LD A, (HL+)
    DEC HL
    INC L
    DEC L
    LD L, 0xab
    CPL
    JR NC, 0xab
    LD SP, 0xcdab
    LD (HL-), A
    INC SP
    INC (HL)
    DEC (HL)
    LD (HL), 0xab
    SCF
    JR C, 0xab
    ADD HL, SP
    LD A, (HL-)
    DEC SP
    INC A
    DEC A
    LD A, 0xab
    CCF
    LD B, B
    LD B, C
    LD B, D
    LD B, E
    LD B, H
    LD B, F
    LD B, (HL)
    LD B, A
    LD C, B
    LD C, C
    LD C, D
    LD C, E
    LD C, H
    LD C, L
    LD C, (HL)
    LD C, A
    LD D, B
    LD D, C
    LD D, D
    LD D, E
    LD D, H
    LD D, L
    LD D, (HL)
    LD D, A
    LD E, B
    LD E, C
    LD E, D
    LD E, E
    LD E, H
    LD E, L
    LD E, (HL)
    LD E, A
    LD H, B
    LD H, C
    LD H, D
    LD H, E
    LD H, H
    LD H, L
    LD H, (HL)
    LD H, A
    LD L, B
    LD L, C
    LD L, D
    LD L, E
    LD L, H
    LD L, L
    LD L, E
    LD L, A
    LD (HL), B
    LD (HL), C
    LD (HL), D
    LD (HL), E
    LD (HL), H
    LD (HL), L
    HALT
    LD (HL), A
    LD A, B
    LD A, C
    LD A, D
    LD A, E
    LD A, H
    LD A, L
    LD A, (HL)
    LD A, A
    ADD A, B
    ADD A, C
    ADD A, D
    ADD A, E
    ADD A, H
    ADD A, L
    ADD A, (HL)
    ADD A, A
    ADC A, B
    ADC A, C
    ADC A, D
    ADC A, E
    ADC A, H
    ADC A, L
    ADC A, (HL)
    ADC A, A
    SUB A, B
    SUB A, C
    SUB A, D
    SUB A, E
    SUB A, H
    SUB A, L
    SUB A, (HL)
    SUB A, A
    SBC A, B
    SBC A, C
    SBC A, D
    SBC A, E
    SBC A, H
    SBC A, L
    SBC A, (HL)
    SBC A, A
    AND A, B
    AND A, C
    AND A, D
    AND A, E
    AND A, H
    AND A, L
    AND A, (HL)
    AND A, A
    XOR A, B
    XOR A, C
    XOR A, D
    XOR A, E
    XOR A, H
    XOR A, L
    XOR A, (HL)
    XOR A, A
    OR A, B
    OR A, C
    OR A, D
    OR A, E
    OR A, H
    OR A, L
    OR A, (HL)
    OR A, A
    CP A, B
    CP A, C
    CP A, D
    CP A, E
    CP A, H
    CP A, L
    CP A, (HL)
    CP A, A
    RET NZ
    POP BC
    JP NZ, 0xcdab
    JP 0xcdab
    CALL NZ, 0xcdab
    PUSH BC
    ADD A, 0xab
    RST 0x0000
    RET Z
    RET
    JP Z, 0xcdab
    RLC B
    RLC C
    RLC D
    RLC E
    RLC H
    RLC L
    RLC (HL)
    RRC A
    RRC B
    RRC C
    RRC D
    RRC E
    RRC H
    RRC L
    RRC (HL)
    RRC A
    RL B
    RL C
    RL D
    RL E
    RL H
    RL L
    RL (HL)
    RR A
    RR B
    RR C
    RR D
    RR E
    RR H
    RR L
    RR (HL)
    RR A
    SLA B
    SLA C
    SLA D
    SLA E
    SLA H
    SLA L
    SLA (HL)
    SRA A
    SRA B
    SRA C
    SRA D
    SRA E
    SRA H
    SRA L
    SRA (HL)
    SRA A
    SWAP B
    SWAP C
    SWAP D
    SWAP E
    SWAP H
    SWAP L
    SWAP (HL)
    SRL A
    SRL B
    SRL C
    SRL D
    SRL E
    SRL H
    SRL L
    SRL (HL)
    SRL A
    BIT 0x00, B
    BIT 0x00, C
    BIT 0x00, D
    BIT 0x00, E
    BIT 0x00, H
    BIT 0x00, L
    BIT 0x00, (HL)
    BIT 0x01, A
    BIT 0x01, B
    BIT 0x01, C
    BIT 0x01, D
    BIT 0x01, E
    BIT 0x01, H
    BIT 0x01, L
    BIT 0x01, (HL)
    BIT 0x01, A
    BIT 0x02, B
    BIT 0x02, C
    BIT 0x02, D
    BIT 0x02, E
    BIT 0x02, H
    BIT 0x02, L
    BIT 0x02, (HL)
    BIT 0x03, A
    BIT 0x03, B
    BIT 0x03, C
    BIT 0x03, D
    BIT 0x03, E
    BIT 0x03, H
    BIT 0x03, L
    BIT 0x03, (HL)
    BIT 0x03, A
    BIT 0x04, B
    BIT 0x04, C
    BIT 0x04, D
    BIT 0x04, E
    BIT 0x04, H
    BIT 0x04, L
    BIT 0x04, (HL)
    BIT 0x05, A
    BIT 0x05, B
    BIT 0x05, C
    BIT 0x05, D
    BIT 0x05, E
    BIT 0x05, H
    BIT 0x05, L
    BIT 0x05, (HL)
    BIT 0x05, A
    BIT 0x06, B
    BIT 0x06, C
    BIT 0x06, D
    BIT 0x06, E
    BIT 0x06, H
    BIT 0x06, L
    BIT 0x06, (HL)
    BIT 0x07, A
    BIT 0x07, B
    BIT 0x07, C
    BIT 0x07, D
    BIT 0x07, E
    BIT 0x07, H
    BIT 0x07, L
    BIT 0x07, (HL)
    BIT 0x07, A
    RES 0x00, B
    RES 0x00, C
    RES 0x00, D
    RES 0x00, E
    RES 0x00, H
    RES 0x00, L
    RES 0x00, (HL)
    RES 0x01, A
    RES 0x01, B
    RES 0x01, C
    RES 0x01, D
    RES 0x01, E
    RES 0x01, H
    RES 0x01, L
    RES 0x01, (HL)
    RES 0x01, A
    RES 0x02, B
    RES 0x02, C
    RES 0x02, D
    RES 0x02, E
    RES 0x02, H
    RES 0x02, L
    RES 0x02, (HL)
    RES 0x03, A
    RES 0x03, B
    RES 0x03, C
    RES 0x03, D
    RES 0x03, E
    RES 0x03, H
    RES 0x03, L
    RES 0x03, (HL)
    RES 0x03, A
    RES 0x04, B
    RES 0x04, C
    RES 0x04, D
    RES 0x04, E
    RES 0x04, H
    RES 0x04, L
    RES 0x04, (HL)
    RES 0x05, A
    RES 0x05, B
    RES 0x05, C
    RES 0x05, D
    RES 0x05, E
    RES 0x05, H
    RES 0x05, L
    RES 0x05, (HL)
    RES 0x05, A
    RES 0x06, B
    RES 0x06, C
    RES 0x06, D
    RES 0x06, E
    RES 0x06, H
    RES 0x06, L
    RES 0x06, (HL)
    RES 0x07, A
    RES 0x07, B
    RES 0x07, C
    RES 0x07, D
    RES 0x07, E
    RES 0x07, H
    RES 0x07, L
    RES 0x07, (HL)
    RES 0x07, A
    SET 0x00, B
    SET 0x00, C
    SET 0x00, D
    SET 0x00, E
    SET 0x00, H
    SET 0x00, L
    SET 0x00, (HL)
    SET 0x01, A
    SET 0x01, B
    SET 0x01, C
    SET 0x01, D
    SET 0x01, E
    SET 0x01, H
    SET 0x01, L
    SET 0x01, (HL)
    SET 0x01, A
    SET 0x02, B
    SET 0x02, C
    SET 0x02, D
    SET 0x02, E
    SET 0x02, H
    SET 0x02, L
    SET 0x02, (HL)
    SET 0x03, A
    SET 0x03, B
    SET 0x03, C
    SET 0x03, D
    SET 0x03, E
    SET 0x03, H
    SET 0x03, L
    SET 0x03, (HL)
    SET 0x03, A
    SET 0x04, B
    SET 0x04, C
    SET 0x04, D
    SET 0x04, E
    SET 0x04, H
    SET 0x04, L
    SET 0x04, (HL)
    SET 0x05, A
    SET 0x05, B
    SET 0x05, C
    SET 0x05, D
    SET 0x05, E
    SET 0x05, H
    SET 0x05, L
    SET 0x05, (HL)
    SET 0x05, A
    SET 0x06, B
    SET 0x06, C
    SET 0x06, D
    SET 0x06, E
    SET 0x06, H
    SET 0x06, L
    SET 0x06, (HL)
    SET 0x07, A
    SET 0x07, B
    SET 0x07, C
    SET 0x07, D
    SET 0x07, E
    SET 0x07, H
    SET 0x07, L
    SET 0x07, (HL)
    SET 0x07, A
    CALL Z, 0xcdab
    CALL 0xcdab
    ADC A, 0xab
    RST 0x0008
    RET NC
    POP DE
    JP NC, 0xcdab
    NOP
    CALL NC, 0xcdab
    PUSH DE
    SUB A, 0xab
    RST 0x0010
    RET C
    RETI
    JP C, 0xcdab
    NOP
    CALL C, 0xcdab
    NOP
    SBC A, 0xab
    RST 0x0018
    LD (0xFF00+0xab), A
    POP HL
    LD (0xFF00+C), A
    NOP
    NOP
    PUSH HL
    AND A, 0xab
    RST 0x0020
    ADD SP, 0xab
    JP HL
    LD (0xcdab), A
    NOP
    NOP
    NOP
    XOR A, 0xab
    RST 0x0028
    LD A, (0xFF00+0xab)
    POP AF
    LD A, (0xFF00+C)
    DI
    NOP
    PUSH AF
    OR A, 0xab
    RST 0x0030
    LD HL, SP+0xab
    LD SP, HL
    LD A, (0xcdab)
    EI
    NOP
    NOP
    CP A, 0xab
    RST 0x0038 |}]

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
