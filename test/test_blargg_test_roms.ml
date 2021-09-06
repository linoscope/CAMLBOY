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


    Passed |}]

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

(*  A:$08 F:Z--- BC:$00FF DE:$CC29 HL:$4C10 SP:$DFE9 PC:$C91A | ADD HL, HL
 *  A:$08 F:Z-H- BC:$00FF DE:$CC29 HL:$9820 SP:$DFE9 PC:$C91B | LD DE, $D81B
 *  A:$08 F:Z-H- BC:$00FF DE:$D81B HL:$9820 SP:$DFE9 PC:$C91E | DEC E
 * @@ -202396,896 +217059,3839 @@
 *  A:$12 F:-N-C BC:$3456 DE:$789A HL:$C60D SP:$DFF5 PC:$C6DD | LD HL, $DEF4
 *  A:$12 F:-N-C BC:$3456 DE:$789A HL:$DEF4 SP:$DFF5 PC:$C6E0 | POP AF
 *  A:$BC F:---- BC:$3456 DE:$789A HL:$DEF4 SP:$DFF7 PC:$C6E1 | JP $DEF8
 * -A:$BC F:---- BC:$3456 DE:$789A HL:$DEF4 SP:$DFF7 PC:$DEF8 | LD B, L
 * -A:$BC F:---- BC:$F456 DE:$789A HL:$DEF4 SP:$DFF7 PC:$DEF9 | NOP
 * -A:$BC F:---- BC:$F456 DE:$789A HL:$DEF4 SP:$DFF7 PC:$DEFA | NOP
 * -A:$BC F:---- BC:$F456 DE:$789A HL:$DEF4 SP:$DFF7 PC:$DEFB | JP $C6E4
 * -A:$BC F:---- BC:$F456 DE:$789A HL:$DEF4 SP:$DFF7 PC:$C6E4 | CALL $C50F+A:$BC F:---- BC:$3456 DE:$789A HL:$DEF4 SP:$DFF7 PC:$DEF8 | LD B, F
 * +A:$BC F:---- BC:$3456 DE:$789A HL:$DEF4 SP:$DFF7 PC:$DEF8 | LD B, F
 * +A:$BC F:---- BC:$0056 DE:$789A HL:$DEF4 SP:$DFF7 PC:$DEF9 | NOP
 * +A:$BC F:---- BC:$0056 DE:$789A HL:$DEF4 SP:$DFF7 PC:$DEFA | NOP *)
