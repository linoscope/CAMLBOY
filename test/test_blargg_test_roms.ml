open Camlboy_lib
open Uints
include Testing_utils

let is_infinite_loop instr =
  let open Instruction in
  match instr with
  | JR (None, i8) -> if Int8.to_int i8 = -2 then true else false
  | _ -> false

let run_test_rom file =
  let rom_bytes = read_rom_file file  in
  let camlboy = Camlboy.create_with_rom ~rom_bytes ~echo_flag:true in
  let rec loop () =
    Camlboy.tick camlboy;
    if is_infinite_loop (Camlboy.For_tests.prev_inst camlboy) then
      ()
    else
      loop ()
  in
  loop ()

let%expect_test "01-special.gb" =
  run_test_rom "../resource/test_roms/blargg/cpu_instrs/individual/01-special.gb";

  [%expect {|
    01-special

    EC5B5B49
    DAA

    Failed #6 |}]

let%expect_test "02-interrupts.gb" =
  run_test_rom "../resource/test_roms/blargg/cpu_instrs/individual/02-interrupts.gb";

  [%expect {|
    02-interrupts


    EI

    Failed #2 |}]

let%expect_test "03-op sp,hl.gb" =
  run_test_rom "../resource/test_roms/blargg/cpu_instrs/individual/03-op sp,hl.gb";

  [%expect {|
    03-op sp,hl

    48 48 C8 C8
    Failed |}]

let%expect_test "04-op r,imm.gb" =
  run_test_rom "../resource/test_roms/blargg/cpu_instrs/individual/04-op r,imm.gb";

  [%expect {|
    04-op r,imm


    Passed |}]

let%expect_test "05-op rp.gb" =
  run_test_rom "../resource/test_roms/blargg/cpu_instrs/individual/05-op rp.gb";

  [%expect {|
    05-op rp


    Passed |}]

let%expect_test "06-ld r,r.gb" =
  run_test_rom "../resource/test_roms/blargg/cpu_instrs/individual/06-ld r,r.gb";

  [%expect {|
    06-ld r,r

    25
    Failed |}]

let%expect_test "07-jr,jp,call,ret,rst.gb" =
  run_test_rom "../resource/test_roms/blargg/cpu_instrs/individual/07-jr,jp,call,ret,rst.gb";

  [%expect {|
    07-jr,jp,call,ret,rst


    Passed |}]

let%expect_test "08-misc instrs.gb" =
  run_test_rom "../resource/test_roms/blargg/cpu_instrs/individual/08-misc instrs.gb";

  [%expect {|
    08-misc instrs


    Passed |}]

let%expect_test "09-op r,r.gb" =
  run_test_rom "../resource/test_roms/blargg/cpu_instrs/individual/09-op r,r.gb";

  [%expect {|
    09-op r,r

    5B 37 5B B7 5B 37 5B 80 5B 81 5B 92 5B 93 5B A4 5B A5 5B B7
    Failed |}]

let%expect_test "10-bit ops.gb" =
  run_test_rom "../resource/test_roms/blargg/cpu_instrs/individual/10-bit ops.gb";

  [%expect {|
    10-bit ops


    Passed |}]

let%expect_test "11-op a,(hl).gb" =
  run_test_rom "../resource/test_roms/blargg/cpu_instrs/individual/11-op a,(hl).gb";

  [%expect {|
    11-op a,(hl)

    5B B6 37
    Failed |}]
(*  A:$CB F:---- BC:$0001 DE:$0810 HL:$DCB0 SP:$DFEB PC:$C52D | POP HL
 * -A:$CB F:---- BC:$0001 DE:$0810 HL:$0120 SP:$DFED PC:$C52E | LD A, L
 * +A:$CB F:---- BC:$0001 DE:$0810 HL:$01A0 SP:$DFED PC:$C52E | LD A, L *)

(*  A:$01 F:---- BC:$0001 DE:$0810 HL:$0204 SP:$DFF1 PC:$C818 | JP $DEF8
 * -A:$01 F:---- BC:$0001 DE:$0810 HL:$0204 SP:$DFF1 PC:$DEF8 | BIT 0, A
 * -A:$01 F:--H- BC:$0001 DE:$0810 HL:$0204 SP:$DFF1 PC:$DEFA | NOP
 * +A:$01 F:---- BC:$0001 DE:$0810 HL:$0204 SP:$DFF1 PC:$DEF8 | BIT $01, A
 * +A:$01 F:Z-H- BC:$0001 DE:$0810 HL:$0204 SP:$DFF1 PC:$DEFA | NOP *)

(*  A:$18 F:ZN-- BC:$FFF0 DE:$0102 HL:$2618 SP:$DFEF PC:$CC11 | ADD HL, HL
 * -A:$18 F:Z--- BC:$FFF0 DE:$0102 HL:$4C30 SP:$DFEF PC:$CC12 | ADD HL, HL
 * -A:$18 F:Z-H- BC:$FFF0 DE:$0102 HL:$9860 SP:$DFEF PC:$CC13 | LD DE, $D81B
 * -A:$18 F:Z-H- BC:$FFF0 DE:$D81B HL:$9860 SP:$DFEF PC:$CC16 | DEC E
 * +A:$18 F:--H- BC:$FFF0 DE:$0102 HL:$4C30 SP:$DFEF PC:$CC12 | ADD HL, HL
 * +A:$18 F:--H- BC:$FFF0 DE:$0102 HL:$9860 SP:$DFEF PC:$CC13 | LD DE, $D81B
 * +A:$18 F:--H- BC:$FFF0 DE:$D81B HL:$9860 SP:$DFEF PC:$CC16 | DEC E *)

(*  A:$61 F:-NH- BC:$FFF0 DE:$0102 HL:$C194 SP:$DFF3 PC:$C0AD | CALL $D801
 * -A:$61 F:-NH- BC:$FFF0 DE:$0102 HL:$C194 SP:$DFF1 PC:$D801 | JP $CF37
 * -A:$61 F:-NH- BC:$FFF0 DE:$0102 HL:$C194 SP:$DFF1 PC:$CF37 | PUSH AF
 * -A:$61 F:-NH- BC:$FFF0 DE:$0102 HL:$C194 SP:$DFEF PC:$CF38 | LD ($FF00+$01), A
 * -A:$61 F:-NH- BC:$FFF0 DE:$0102 HL:$C194 SP:$DFEF PC:$CF3A | LD A, $81
 * -A:$81 F:-NH- BC:$FFF0 DE:$0102 HL:$C194 SP:$DFEF PC:$CF3C | LD ($FF00+$02), A
 * -A:$81 F:-NH- BC:$FFF0 DE:$0102 HL:$C194 SP:$DFEF PC:$CF3E | PUSH AF
 * +A:$61 F:-NH- BC:$FFF0 DE:$0102 HL:$C194 SP:$DFF1 PC:$D801 | JP $CF50
 * +A:$61 F:-NH- BC:$FFF0 DE:$0102 HL:$C194 SP:$DFF1 PC:$CF50 | SET $01, L
 * +A:$61 F:-NH- BC:$FFF0 DE:$0102 HL:$C196 SP:$DFF1 PC:$CF52 | LD E, D
 * +A:$61 F:-NH- BC:$FFF0 DE:$0101 HL:$C196 SP:$DFF1 PC:$CF53 | RST $0008
 * +A:$61 F:-NH- BC:$FFF0 DE:$0101 HL:$C196 SP:$DFEF PC:$0008 | NOP
 * +A:$61 F:-NH- BC:$FFF0 DE:$0101 HL:$C196 SP:$DFEF PC:$0009 | NOP
 * +A:$61 F:-NH- BC:$FFF0 DE:$0101 HL:$C196 SP:$DFEF PC:$000A | NOP
 * +A:$61 F:-NH- BC:$FFF0 DE:$0101 HL:$C196 SP:$DFEF PC:$000B | NOP *)

(*  A:$18 F:ZN-- BC:$FFF0 DE:$0102 HL:$2618 SP:$DFEF PC:$CC11 | ADD HL, HL
 * -A:$18 F:Z--- BC:$FFF0 DE:$0102 HL:$4C30 SP:$DFEF PC:$CC12 | ADD HL, HL
 * +A:$18 F:Z-H- BC:$FFF0 DE:$0102 HL:$4C30 SP:$DFEF PC:$CC12 | ADD HL, HL *)

(*  A:$50 F:-N-- BC:$FFF0 DE:$0102 HL:$D81B SP:$DFED PC:$CBC6 | DEC (HL)
 * -A:$50 F:-N-- BC:$FFF0 DE:$0102 HL:$D81B SP:$DFED PC:$CBC7 | LD L, (HL)
 * -A:$50 F:-N-- BC:$FFF0 DE:$0102 HL:$D81A SP:$DFED PC:$CBC8 | LD (HL), A
 * -A:$50 F:-N-- BC:$FFF0 DE:$0102 HL:$D81A SP:$DFED PC:$CBC9 | POP HL
 * +A:$50 F:-N-- BC:$FFF0 DE:$0102 HL:$D81B SP:$DFED PC:$CBC7 | LD L, E
 * +A:$50 F:-N-- BC:$FFF0 DE:$0102 HL:$D802 SP:$DFED PC:$CBC8 | LD (HL), A
 * +A:$50 F:-N-- BC:$FFF0 DE:$0102 HL:$D802 SP:$DFED PC:$CBC9 | POP HL *)
