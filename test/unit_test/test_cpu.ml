open Camlboy_lib
open Uints

module Bus = Mock_bus
module Cpu = Cpu.Make(Mock_bus)

let create_cpu
    ?(a = 0x00) ?(b = 0x00) ?(c = 0x00)
    ?(d = 0x00) ?(e = 0x00) ?(h = 0x00) ?(l = 0x00)
    ?(carry=false) ?(half_carry=false) ?(sub=false) ?(zero=false)
    ?(pc = 0x00) ?(sp = 0x00)
    ?(halted = false)
    ?(bus = Bus.create ~size:0x10)
    ?(ime = true) () =
  let registers = Registers.create () in
  Registers.write_r registers A (Uint8.of_int a);
  Registers.write_r registers B (Uint8.of_int b);
  Registers.write_r registers C (Uint8.of_int c);
  Registers.write_r registers D (Uint8.of_int d);
  Registers.write_r registers E (Uint8.of_int e);
  Registers.write_r registers H (Uint8.of_int h);
  Registers.write_r registers L (Uint8.of_int l);
  Registers.set_flags registers ~c:carry ~h:half_carry ~n:sub ~z:zero ();
  let zeros = Bytes.create 0x10 in
  Bytes.fill zeros 0 0x10 (Char.chr 0);
  Cpu.create
    ~bus
    ~ic:(Interrupt_controller.create ~ie_addr:Uint16.(of_int 0xF) ~if_addr:Uint16.(of_int 0xE))
    ~registers
    ~pc:(Uint16.of_int pc)
    ~sp:(Uint16.of_int sp)
    ~halted
    ~ime

let execute_result t inst =
  let inst_info = Inst_info.{len=(Uint16.of_int 2); mcycles={branched=1; not_branched=2; }; inst} in
  Cpu.For_tests.execute t inst_info
  |> (fun x -> ignore (x : int))


let print_execute_result t inst =
  execute_result t inst;

  Cpu.show t
  |> print_endline

let print_addr_content bus addr =
  Bus.read_byte bus (Uint16.of_int addr)
  |> Uint8.show
  |> print_endline


let%expect_test "NOP" =
  let t = create_cpu () in

  NOP
  |> print_execute_result t;

  [%expect {|
    A:$00 F:---- BC:$0000 DE:$0000 HL:$0000 SP:$0000 PC:$0000 |}]

let%expect_test "LD A, 0xAB" =
  let t = create_cpu () in

  LD8 (R A, Immediate8 (Uint8.of_int 0xAB))
  |> print_execute_result t;

  [%expect {|
    A:$AB F:---- BC:$0000 DE:$0000 HL:$0000 SP:$0000 PC:$0000 |}]

let%expect_test "LD B, 0xAB" =
  let t = create_cpu () in

  LD8 (R B, Immediate8 (Uint8.of_int 0xAB))
  |> print_execute_result t;

  [%expect {|
    A:$00 F:---- BC:$AB00 DE:$0000 HL:$0000 SP:$0000 PC:$0000 |}]

let%expect_test "LD16 BC, 0xAABB" =
  let t = create_cpu () in

  LD16 (RR BC, Immediate16 (Uint16.of_int 0x9988))
  |> print_execute_result t;

  [%expect {|
    A:$00 F:---- BC:$9988 DE:$0000 HL:$0000 SP:$0000 PC:$0000 |}]

let%expect_test "LD8 A, (HL)" =
  let bus = Bus.create ~size:0x10 in
  Bus.write_byte bus ~addr:Uint16.(of_int 0x2) ~data:Uint8.(of_int 0xAB);
  let t = create_cpu ~l:0x2 ~bus () in

  LD8 (R A, RR_indirect HL)
  |> print_execute_result t;

  [%expect {|
    A:$AB F:---- BC:$0000 DE:$0000 HL:$0002 SP:$0000 PC:$0000 |}]

let%expect_test "LD8 (HL), B" =
  let bus = Bus.create ~size:0x10 in
  let t = create_cpu ~l:0x2 ~b:0xAB ~bus () in

  LD8 (RR_indirect HL, R B)
  |> print_execute_result t;

  [%expect {|
    A:$00 F:---- BC:$AB00 DE:$0000 HL:$0002 SP:$0000 PC:$0000 |}];

  print_addr_content bus 0x2;
  [%expect {|$AB|}]

let%expect_test "LD8 (HL+), B" =
  let bus = Bus.create ~size:0x10 in
  let t = create_cpu ~l:0x2 ~b:0xAB ~bus () in

  LD8 (HL_inc, R B)
  |> print_execute_result t;

  [%expect{|
    A:$00 F:---- BC:$AB00 DE:$0000 HL:$0003 SP:$0000 PC:$0000 |}];

  print_addr_content bus 0x2;
  [%expect {|$AB|}]

let%expect_test "LD8 (HL-), B" =
  let bus = Bus.create ~size:0x10 in
  let t = create_cpu ~l:0x2 ~b:0xAB ~bus () in

  LD8 (HL_dec, R B)
  |> print_execute_result t;

  [%expect{|
    A:$00 F:---- BC:$AB00 DE:$0000 HL:$0001 SP:$0000 PC:$0000 |}];

  print_addr_content bus 0x2;
  [%expect {|$AB|}]

let%expect_test "LD8 A, (HL+)" =
  let bus = Bus.create ~size:0x10 in
  Bus.write_byte bus ~addr:Uint16.(of_int 0x2) ~data:Uint8.(of_int 0xBB);
  Bus.write_byte bus ~addr:Uint16.(of_int 0x3) ~data:Uint8.(of_int 0xCC);
  Bus.write_byte bus ~addr:Uint16.(of_int 0x1) ~data:Uint8.(of_int 0xDD);
  let t = create_cpu ~l:0x2 ~bus () in

  LD8 (R A, HL_inc)
  |> print_execute_result t;

  [%expect{|
    A:$BB F:---- BC:$0000 DE:$0000 HL:$0003 SP:$0000 PC:$0000 |}]

let%expect_test "LD8 A, (HL-)" =
  let bus = Bus.create ~size:0x10 in
  Bus.write_byte bus ~addr:Uint16.(of_int 0x2) ~data:Uint8.(of_int 0xBB);
  Bus.write_byte bus ~addr:Uint16.(of_int 0x3) ~data:Uint8.(of_int 0xCC);
  Bus.write_byte bus ~addr:Uint16.(of_int 0x1) ~data:Uint8.(of_int 0xDD);
  let t = create_cpu ~l:0x2 ~bus () in

  LD8 (R A, HL_dec)
  |> print_execute_result t;

  [%expect{|
    A:$BB F:---- BC:$0000 DE:$0000 HL:$0001 SP:$0000 PC:$0000 |}]

let%expect_test "LD8 A, ($FF00+$44)" =
  let bus = Bus.create ~size:0xFFFF in
  Bus.write_byte bus ~addr:Uint16.(of_int 0xFF44) ~data:Uint8.(of_int 0xAA);
  let t = create_cpu ~bus () in

  LD8 (R A, FF00_offset (Uint8.of_int 0x44))
  |> print_execute_result t;

  [%expect{|
    A:$AA F:---- BC:$0000 DE:$0000 HL:$0000 SP:$0000 PC:$0000 |}]

let%expect_test "LD16 HL, SP+0x03" =
  let t = create_cpu ~sp:0x1234 () in

  LD16 (RR HL, SP_offset (Int8.of_int 0x03))
  |> print_execute_result t;

  [%expect{|
    A:$00 F:---- BC:$0000 DE:$0000 HL:$1237 SP:$1234 PC:$0000 |}]

let%expect_test "LD16 HL, SP+0x01 (carry + half carry)" =
  let t = create_cpu ~sp:0x00FF () in

  LD16 (RR HL, SP_offset (Int8.of_int 0x01))
  |> print_execute_result t;

  [%expect{|
    A:$00 F:--HC BC:$0000 DE:$0000 HL:$0100 SP:$00FF PC:$0000 |}]

let%expect_test "LD16 HL, SP-0x01 (carry + half carry)" =
  let t = create_cpu ~l:0xFF ~sp:0x0001 () in

  LD16 (RR HL, SP_offset (Int8.of_int (-0x01)))
  |> print_execute_result t;

  (* Carry because we are calculating 0x1 - 0x1 = 0x1 + 0xFFFF = 0x0000*)
  [%expect{|
    A:$00 F:--HC BC:$0000 DE:$0000 HL:$0000 SP:$0001 PC:$0000 |}]

let%expect_test "LD16 HL, SP-0x01 (no carry)" =
  let t = create_cpu ~sp:0x0000 () in

  LD16 (RR HL, SP_offset (Int8.of_int (-0x01)))
  |> print_execute_result t;

  (* No carry because we are calculating 0x0 - 0x1 = 0x0 + 0xFFFF = 0xFFFF*)
  [%expect{|
    A:$00 F:---- BC:$0000 DE:$0000 HL:$FFFF SP:$0000 PC:$0000 |}]

let%expect_test "LD16 SP, 0xABCD" =
  let t = create_cpu () in

  LD16 (SP, Immediate16 (0xabcd |> Uint16.of_int))
  |> print_execute_result t;

  [%expect{|
    A:$00 F:---- BC:$0000 DE:$0000 HL:$0000 SP:$ABCD PC:$0000 |}]

let%expect_test "ADD A, 0xA0 (no half-carry/carry)" =
  let t = create_cpu ~a:0x01 () in

  ADD8 (R A, Immediate8 (Uint8.of_int 0xA0))
  |> print_execute_result t;

  [%expect{|
    A:$A1 F:---- BC:$0000 DE:$0000 HL:$0000 SP:$0000 PC:$0000 |}]

let%expect_test "ADD A, 0x0F (half-carry)" =
  let t = create_cpu ~a:0x01 () in

  ADD8 (R A, Immediate8 (Uint8.of_int 0x0F))
  |> print_execute_result t;

  [%expect{|
    A:$10 F:--H- BC:$0000 DE:$0000 HL:$0000 SP:$0000 PC:$0000 |}]

let%expect_test "ADD A, 0xFF (half-carry + carry)" =
  let t = create_cpu ~a:0x1 () in

  ADD8 (R A, Immediate8 (Uint8.of_int 0xFF))
  |> print_execute_result t;

  [%expect{|
    A:$00 F:Z-HC BC:$0000 DE:$0000 HL:$0000 SP:$0000 PC:$0000 |}]

let%expect_test "ADD SP, 0x01 (both carry and half carry)" =
  let t = create_cpu ~sp:0xAAFF () in

  ADDSP (Int8.of_int 0x01)
  |> print_execute_result t;

  [%expect{|
    A:$00 F:--HC BC:$0000 DE:$0000 HL:$0000 SP:$AB00 PC:$0000 |}]

let%expect_test "ADD SP, 0x01 (no carries)" =
  let t = create_cpu ~sp:0x0080 () in

  ADDSP (Int8.of_int 0x01)
  |> print_execute_result t;

  [%expect{|
    A:$00 F:---- BC:$0000 DE:$0000 HL:$0000 SP:$0081 PC:$0000 |}]

let%expect_test "ADD SP, -0x1 (no carry)" =
  let t = create_cpu ~sp:0x0000 () in

  ADDSP (Int8.of_int (-0x1))
  |> print_execute_result t;

  (* No carry because we are calculating 0x0 - 0x1 = 0x0 + 0xFFFF = 0xFFFF*)
  [%expect{|
    A:$00 F:---- BC:$0000 DE:$0000 HL:$0000 SP:$FFFF PC:$0000 |}]

let%expect_test "ADD SP, -0x1 (no carry)" =
  let t = create_cpu ~sp:0x0001 () in

  ADDSP (Int8.of_int (-0x1))
  |> print_execute_result t;

  (* Carry because we are calculating 0x1 - 0x1 = 0x1 + 0xFFFF = 0x0000*)
  [%expect{|
    A:$00 F:--HC BC:$0000 DE:$0000 HL:$0000 SP:$0000 PC:$0000 |}]

let%expect_test "ADD HL, BC (half carry + carry)" =
  let t = create_cpu ~h:0xFF ~l:0x00 ~b:0x01 ~c:0x00 () in

  ADD16 (RR HL, RR BC)
  |> print_execute_result t;

  [%expect{|
    A:$00 F:--HC BC:$0100 DE:$0000 HL:$0000 SP:$0000 PC:$0000 |}]

let%expect_test "ADD HL, HL (no carries)" =
  let t = create_cpu ~h:0x26 ~l:0x18 ~zero:true () in

  ADD16 (RR HL, RR HL)
  |> print_execute_result t;

  [%expect{|
    A:$00 F:Z--- BC:$0000 DE:$0000 HL:$4C30 SP:$0000 PC:$0000 |}]

let%expect_test "ADC A, 0xFF (half-carry + carry)" =
  let t = create_cpu ~a:0x1 ~carry:true () in

  ADC (R A, Immediate8 (Uint8.of_int 0xFE))
  |> print_execute_result t;

  [%expect{|
    A:$00 F:Z-HC BC:$0000 DE:$0000 HL:$0000 SP:$0000 PC:$0000 |}]

let%expect_test "AND A, $F0" =
  let t = create_cpu ~a:0x00 () in

  AND (R A, Immediate8 (Uint8.of_int 0xF0))
  |> print_execute_result t;

  [%expect {| A:$00 F:Z-H- BC:$0000 DE:$0000 HL:$0000 SP:$0000 PC:$0000 |}]


let%expect_test "INC HL" =
  let t = create_cpu ~h:0xaa ~l:0xbb () in

  INC16 (RR HL)
  |> print_execute_result t;

  [%expect{|
    A:$00 F:---- BC:$0000 DE:$0000 HL:$AABC SP:$0000 PC:$0000 |}]

let%expect_test "INC A (no carry)" =
  let t = create_cpu ~a:0x10 () in

  INC (R A)
  |> print_execute_result t;

  [%expect{|
    A:$11 F:---- BC:$0000 DE:$0000 HL:$0000 SP:$0000 PC:$0000 |}]

let%expect_test "INC A (with carry)" =
  let t = create_cpu ~a:0x0F () in

  INC (R A)
  |> print_execute_result t;

  [%expect{|
    A:$10 F:--H- BC:$0000 DE:$0000 HL:$0000 SP:$0000 PC:$0000 |}]

let%expect_test "RLCA" =
  let t = create_cpu ~a:0b10000001 () in

  RLCA
  |> print_execute_result t;

  [%expect {|
    A:$03 F:---C BC:$0000 DE:$0000 HL:$0000 SP:$0000 PC:$0000 |}]

let%expect_test "RLA when c=1" =
  let t = create_cpu ~a:0b00000001 ~carry:true () in

  RLA
  |> print_execute_result t;

  [%expect {|
    A:$03 F:---- BC:$0000 DE:$0000 HL:$0000 SP:$0000 PC:$0000 |}]

let%expect_test "RLA when c=0" =
  let t = create_cpu ~a:0b00000001 ~carry:false () in

  RLA
  |> print_execute_result t;

  [%expect {|
    A:$02 F:---- BC:$0000 DE:$0000 HL:$0000 SP:$0000 PC:$0000 |}]

let%expect_test "RLA (always unset zero flag)" =
  let t = create_cpu ~a:0b10000000 ~zero:true ~carry:false () in

  RLA
  |> print_execute_result t;

  [%expect {|
    A:$00 F:---C BC:$0000 DE:$0000 HL:$0000 SP:$0000 PC:$0000 |}]


let%expect_test "RRCA" =
  let t = create_cpu ~a:0b00010001 () in

  RRCA
  |> print_execute_result t;

  [%expect {|
    A:$88 F:---C BC:$0000 DE:$0000 HL:$0000 SP:$0000 PC:$0000 |}]

let%expect_test "RRA" =
  let t = create_cpu ~a:0b00010000 ~carry:true () in

  RRA
  |> print_execute_result t;

  [%expect {|
    A:$88 F:---- BC:$0000 DE:$0000 HL:$0000 SP:$0000 PC:$0000 |}]

let%expect_test "RRA no carry" =
  let t = create_cpu ~a:0b00010000 ~carry:false () in

  RRA
  |> print_execute_result t;

  [%expect {|
    A:$08 F:---- BC:$0000 DE:$0000 HL:$0000 SP:$0000 PC:$0000 |}]

let%expect_test "RRA sets carry" =
  let t = create_cpu ~a:0b00010001 ~carry:false () in

  RRA
  |> print_execute_result t;

  [%expect {|
    A:$08 F:---C BC:$0000 DE:$0000 HL:$0000 SP:$0000 PC:$0000 |}]

let%expect_test "RLC A" =
  let t = create_cpu ~a:0b10000001 () in

  RLC (R A)
  |> print_execute_result t;

  [%expect {|
    A:$03 F:---C BC:$0000 DE:$0000 HL:$0000 SP:$0000 PC:$0000 |}]

let%expect_test "RLC A (sets zero flag)" =
  let t = create_cpu ~a:0b00000000 () in

  RLC (R A)
  |> print_execute_result t;

  [%expect {|
    A:$00 F:Z--- BC:$0000 DE:$0000 HL:$0000 SP:$0000 PC:$0000 |}]

let%expect_test "RL A" =
  let t = create_cpu ~a:0b00000001 ~carry:true () in

  RL (R A)
  |> print_execute_result t;

  [%expect {|
    A:$03 F:---- BC:$0000 DE:$0000 HL:$0000 SP:$0000 PC:$0000 |}]

let%expect_test "RL A (sets zero flag and carry flag)" =
  let t = create_cpu ~a:0b10000000 () in

  RL (R A)
  |> print_execute_result t;

  [%expect {|
    A:$00 F:Z--C BC:$0000 DE:$0000 HL:$0000 SP:$0000 PC:$0000 |}]

let%expect_test "RRC A" =
  let t = create_cpu ~a:0b00010001 () in

  RRC (R A)
  |> print_execute_result t;

  [%expect {|
    A:$88 F:---C BC:$0000 DE:$0000 HL:$0000 SP:$0000 PC:$0000 |}]

let%expect_test "RRC A (sets zero flag)" =
  let t = create_cpu ~a:0b00000000 () in

  RRC (R A)
  |> print_execute_result t;

  [%expect {|
    A:$00 F:Z--- BC:$0000 DE:$0000 HL:$0000 SP:$0000 PC:$0000 |}]

let%expect_test "RR A" =
  let t = create_cpu ~a:0b00010000 ~carry:true () in

  RR (R A)
  |> print_execute_result t;

  [%expect {|
    A:$88 F:---- BC:$0000 DE:$0000 HL:$0000 SP:$0000 PC:$0000 |}]

let%expect_test "RR A no carry" =
  let t = create_cpu ~a:0b00010000 ~carry:false () in

  RR (R A)
  |> print_execute_result t;

  [%expect {|
    A:$08 F:---- BC:$0000 DE:$0000 HL:$0000 SP:$0000 PC:$0000 |}]

let%expect_test "RR A sets zero flag and carry flag" =
  let t = create_cpu ~a:0b00000001 ~carry:false () in

  RR (R A)
  |> print_execute_result t;

  [%expect {|
    A:$00 F:Z--C BC:$0000 DE:$0000 HL:$0000 SP:$0000 PC:$0000 |}]

let%expect_test "SLA" =
  let t = create_cpu ~a:0b10000001 () in

  SLA (R A)
  |> print_execute_result t;

  [%expect {|
    A:$02 F:---C BC:$0000 DE:$0000 HL:$0000 SP:$0000 PC:$0000 |}]

let%expect_test "SLA set zero flag" =
  let t = create_cpu ~a:0b10000000 () in

  SLA (R A)
  |> print_execute_result t;

  [%expect {|
    A:$00 F:Z--C BC:$0000 DE:$0000 HL:$0000 SP:$0000 PC:$0000 |}]

let%expect_test "SLA no carry" =
  let t = create_cpu ~a:0b00001000 () in

  SLA (R A)
  |> print_execute_result t;

  [%expect {|
    A:$10 F:---- BC:$0000 DE:$0000 HL:$0000 SP:$0000 PC:$0000 |}]

let%expect_test "SRA" =
  let t = create_cpu ~a:0b10000001 () in

  SRA (R A)
  |> print_execute_result t;

  [%expect {|
    A:$C0 F:---C BC:$0000 DE:$0000 HL:$0000 SP:$0000 PC:$0000 |}]

let%expect_test "SRA zero flag" =
  let t = create_cpu ~a:0b00000000 () in

  SRA (R A)
  |> print_execute_result t;

  [%expect {|
    A:$00 F:Z--- BC:$0000 DE:$0000 HL:$0000 SP:$0000 PC:$0000 |}]


let%expect_test "SRL" =
  let t = create_cpu ~a:0b10000001 () in

  SRL (R A)
  |> print_execute_result t;

  [%expect {|
    A:$40 F:---C BC:$0000 DE:$0000 HL:$0000 SP:$0000 PC:$0000 |}]

let%expect_test "BIT (0, A) when A = 0b00000001 (test on 1 bit)" =
  let t = create_cpu ~a:0b00000001 ~sub:true () in

  BIT (0, R A)
  |> print_execute_result t;

  [%expect {|
    A:$01 F:--H- BC:$0000 DE:$0000 HL:$0000 SP:$0000 PC:$0000 |}]

let%expect_test "BIT (5, A) when A = 0b00100000 (test on 1 bit)" =
  let t = create_cpu ~a:0b00100000 ~sub:true () in

  BIT (5, R A)
  |> print_execute_result t;

  [%expect {|
    A:$20 F:--H- BC:$0000 DE:$0000 HL:$0000 SP:$0000 PC:$0000 |}]

let%expect_test "SET (5, A) when A = 0b00000000" =
  let t = create_cpu ~a:0b00000000 () in

  SET (5, R A)
  |> print_execute_result t;

  [%expect {|
    A:$20 F:---- BC:$0000 DE:$0000 HL:$0000 SP:$0000 PC:$0000 |}]

let%expect_test "RES (4, A) when A = 0b00010011" =
  let t = create_cpu ~a:0b00010011 () in

  RES (4, R A)
  |> print_execute_result t;

  [%expect {|
    A:$03 F:---- BC:$0000 DE:$0000 HL:$0000 SP:$0000 PC:$0000 |}]

let%expect_test "RES (4, A) when A = 0b00000011" =
  let t = create_cpu ~a:0b00000011 () in

  RES (4, R A)
  |> print_execute_result t;

  [%expect {|
    A:$03 F:---- BC:$0000 DE:$0000 HL:$0000 SP:$0000 PC:$0000 |}]

let%expect_test "PUSH BC" =
  let bus = Bus.create ~size:0x10 in
  let t = create_cpu ~b:0xBB ~c:0xCC ~sp:8 ~bus () in

  PUSH BC
  |> print_execute_result t;

  [%expect {|
    A:$00 F:---- BC:$BBCC DE:$0000 HL:$0000 SP:$0006 PC:$0000 |}];

  print_addr_content bus 0x7;
  print_addr_content bus 0x6;
  [%expect {|
     $BB
     $CC|}]

let%expect_test "POP BC" =
  let bus = Bus.create ~size:0x10 in
  let t = create_cpu ~b:0xBB ~c:0xCC ~sp:6 ~bus () in
  Bus.write_byte bus ~addr:Uint16.(of_int 0x7) ~data:Uint8.(of_int 0xBB);
  Bus.write_byte bus ~addr:Uint16.(of_int 0x6) ~data:Uint8.(of_int 0xCC);

  POP BC
  |> print_execute_result t;

  [%expect {|
    A:$00 F:---- BC:$BBCC DE:$0000 HL:$0000 SP:$0008 PC:$0000 |}]

let%expect_test "JP 0x0010" =
  let t = create_cpu  () in

  JP (None, Immediate16 Uint16.(of_int 0x0010))
  |> print_execute_result t;

  [%expect {|
    A:$00 F:---- BC:$0000 DE:$0000 HL:$0000 SP:$0000 PC:$0010 |}]

let%expect_test "JP NZ, 0x0010 when z=0" =
  let t = create_cpu  ~zero:false () in

  JP (NZ, Immediate16 Uint16.(of_int 0x0010))
  |> print_execute_result t;

  [%expect {|
    A:$00 F:---- BC:$0000 DE:$0000 HL:$0000 SP:$0000 PC:$0010 |}]

let%expect_test "JP NZ, 0x0010 when z=1" =
  let t = create_cpu  ~zero:true () in

  JP (NZ, Immediate16 Uint16.(of_int 0x0010))
  |> print_execute_result t;

  [%expect {|
    A:$00 F:Z--- BC:$0000 DE:$0000 HL:$0000 SP:$0000 PC:$0000 |}]

let%expect_test "JP HL" =
  let t = create_cpu ~h:0xAA ~l:0xBB  () in

  JP (None, RR HL)
  |> print_execute_result t;

  [%expect {|
    A:$00 F:---- BC:$0000 DE:$0000 HL:$AABB SP:$0000 PC:$AABB |}]

let%expect_test "JR 0x0c" =
  let t = create_cpu ~pc:2 () in

  JR (None, Int8.of_byte (Uint8.of_int 0x0c))
  |> print_execute_result t;

  [%expect {|
    A:$00 F:---- BC:$0000 DE:$0000 HL:$0000 SP:$0000 PC:$000E |}]

let%expect_test "JR C, 0x0e when c=1" =
  let t = create_cpu ~carry:true ~pc:2 () in

  JR (C, Int8.of_int 0x0c)
  |> print_execute_result t;

  [%expect {|
    A:$00 F:---C BC:$0000 DE:$0000 HL:$0000 SP:$0000 PC:$000E |}]

let%expect_test "JR 0xFB when pc = 0x000A" =
  let t = create_cpu ~pc:0x000A () in

  JR (None, Int8.of_int 0xFB)
  |> print_execute_result t;

  [%expect {|
    A:$00 F:---- BC:$0000 DE:$0000 HL:$0000 SP:$0000 PC:$0005 |}]

let%expect_test "JR NC, 0x0e when c=1" =
  let t = create_cpu ~carry:true ~pc:2 () in

  JR (NC, Int8.of_int 0x0e)
  |> print_execute_result t;

  [%expect {|
    A:$00 F:---C BC:$0000 DE:$0000 HL:$0000 SP:$0000 PC:$0002 |}]

let%expect_test "JR NZ, -14 when z=0" =
  let t = create_cpu ~zero:false ~pc:(0xFF) () in

  JR (NZ, Int8.of_int (-1))
  |> print_execute_result t;

  [%expect {|
    A:$00 F:---- BC:$0000 DE:$0000 HL:$0000 SP:$0000 PC:$00FE |}]

let%expect_test "CALL 0x0010" =
  let bus = Bus.create ~size:0x10 in
  let t = create_cpu ~bus ~pc:0xBBCC ~sp:0x8 () in

  CALL (None, Uint16.(of_int 0x0010))
  |> print_execute_result t;

  [%expect {|
    A:$00 F:---- BC:$0000 DE:$0000 HL:$0000 SP:$0006 PC:$0010 |}];

  print_addr_content bus 0x7;
  print_addr_content bus 0x6;
  [%expect {|
     $BB
     $CC|}]

let%expect_test "RET" =
  let bus = Bus.create ~size:0x10 in
  let t = create_cpu ~sp:6 ~bus () in
  Bus.write_byte bus ~addr:Uint16.(of_int 0x7) ~data:Uint8.(of_int 0xBB);
  Bus.write_byte bus ~addr:Uint16.(of_int 0x6) ~data:Uint8.(of_int 0xCC);

  RET None
  |> print_execute_result t;

  [%expect {|
    A:$00 F:---- BC:$0000 DE:$0000 HL:$0000 SP:$0008 PC:$BBCC |}]

let%expect_test "RST 0x08" =
  let bus = Bus.create ~size:0x10 in
  let t = create_cpu ~pc:0xBBCC ~sp:8 ~bus () in

  RST (Uint16.of_int 0x08)
  |> print_execute_result t;

  [%expect {|
    A:$00 F:---- BC:$0000 DE:$0000 HL:$0000 SP:$0006 PC:$0008 |}];

  print_addr_content bus 0x7;
  print_addr_content bus 0x6;
  [%expect {|
     $BB
     $CC|}]

let%expect_test "DAA" =
  let t = create_cpu ~a:0xF0 () in

  DAA
  |> print_execute_result t;

  [%expect {|
    A:$50 F:---C BC:$0000 DE:$0000 HL:$0000 SP:$0000 PC:$0000 |}]

let%expect_test "DAA" =
  let t = create_cpu ~a:0x9A () in

  DAA
  |> print_execute_result t;

  [%expect {|
    A:$00 F:Z--C BC:$0000 DE:$0000 HL:$0000 SP:$0000 PC:$0000 |}]
