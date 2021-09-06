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
(*  A:$12 F:---- BC:$5691 DE:$9ABC HL:$0000 SP:$0000 PC:$C63F | JP $DEF8
 * -A:$12 F:---- BC:$5691 DE:$9ABC HL:$0000 SP:$0000 PC:$DEF8 | ADD SP, -1
 * +A:$12 F:---- BC:$5691 DE:$9ABC HL:$0000 SP:$0000 PC:$DEF8 | ADD SP, $FF *)

(*  A:$12 F:---- BC:$5691 DE:$9ABC HL:$0000 SP:$0000 PC:$DEF8 | ADD SP, -1
 * -A:$12 F:---- BC:$5691 DE:$9ABC HL:$0000 SP:$FFFF PC:$DEFA | NOP
 * +A:$12 F:--HC BC:$5691 DE:$9ABC HL:$0000 SP:$FFFF PC:$DEFA | NOP *)

(*  A:$12 F:---- BC:$5691 DE:$9ABC HL:$0000 SP:$000F PC:$DEF8 | LD HL, SP+1
 * -A:$12 F:--H- BC:$5691 DE:$9ABC HL:$0010 SP:$000F PC:$DEFA | NOP
 * +A:$12 F:---- BC:$5691 DE:$9ABC HL:$0010 SP:$000F PC:$DEFA | NOP *)
