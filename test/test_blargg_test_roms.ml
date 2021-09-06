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

    48 C8 C8
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
(*  A:$12 F:---- BC:$5691 DE:$9ABC HL:$0000 SP:$0080 PC:$C63F | JP $DEF8
 * -A:$12 F:---- BC:$5691 DE:$9ABC HL:$0000 SP:$0080 PC:$DEF8 | ADD SP, 1
 * -A:$12 F:---- BC:$5691 DE:$9ABC HL:$0000 SP:$0081 PC:$DEFA | NOP
 * -A:$12 F:---- BC:$5691 DE:$9ABC HL:$0000 SP:$0081 PC:$DEFB | JP $C642
 * -A:$12 F:---- BC:$5691 DE:$9ABC HL:$0000 SP:$0081 PC:$C642 | LD ($DD02), SP
 * -A:$12 F:---- BC:$5691 DE:$9ABC HL:$0000 SP:$0081 PC:$C645 | LD SP, $DF70
 * -A:$12 F:---- BC:$5691 DE:$9ABC HL:$0000 SP:$DF70 PC:$C648 | CALL $C50F
 * -A:$12 F:---- BC:$5691 DE:$9ABC HL:$0000 SP:$DF6E PC:$C50F | PUSH HL
 * -A:$12 F:---- BC:$5691 DE:$9ABC HL:$0000 SP:$DF6C PC:$C510 | PUSH AF
 * -A:$12 F:---- BC:$5691 DE:$9ABC HL:$0000 SP:$DF6A PC:$C511 | LD L, A
 * -A:$12 F:---- BC:$5691 DE:$9ABC HL:$0012 SP:$DF6A PC:$C512 | LD A, ($FF00+$80)
 * -A:$61 F:---- BC:$5691 DE:$9ABC HL:$0012 SP:$DF6A PC:$C514 | XOR A, L
 * +A:$12 F:---- BC:$5691 DE:$9ABC HL:$0000 SP:$0080 PC:$DEF8 | ADD SP, $01
 * +A:$12 F:---C BC:$5691 DE:$9ABC HL:$0000 SP:$0081 PC:$DEFA | NOP
 * +A:$12 F:---C BC:$5691 DE:$9ABC HL:$0000 SP:$0081 PC:$DEFB | JP $C642
 * +A:$12 F:---C BC:$5691 DE:$9ABC HL:$0000 SP:$0081 PC:$C642 | LD ($DD02), SP
 * +A:$12 F:---C BC:$5691 DE:$9ABC HL:$0000 SP:$0081 PC:$C645 | LD SP, $DF70
 * +A:$12 F:---C BC:$5691 DE:$9ABC HL:$0000 SP:$DF70 PC:$C648 | CALL $C50F
 * +A:$12 F:---C BC:$5691 DE:$9ABC HL:$0000 SP:$DF6E PC:$C50F | PUSH HL
 * +A:$12 F:---C BC:$5691 DE:$9ABC HL:$0000 SP:$DF6C PC:$C510 | PUSH AF
 * +A:$12 F:---C BC:$5691 DE:$9ABC HL:$0000 SP:$DF6A PC:$C511 | LD L, A
 * +A:$12 F:---C BC:$5691 DE:$9ABC HL:$0012 SP:$DF6A PC:$C512 | LD A, ($FF00+$80) *)
