open Camlboy_lib
open Uints

module Camlboy = Camlboy.Make (Rom_only)

(** Blargg tests end with "JR -2" infinite loop *)
let is_infinite_loop instr =
  let open Instruction in
  match instr with
  | JR (None, i8) -> if Int8.to_int i8 = -2 then true else false
  | _ -> false

let run_test_rom file =
  let rom_bytes = Read_rom_file.f file  in
  let camlboy = Camlboy.create_with_rom ~rom_bytes ~echo_flag:true in
  let rec loop () =
    ignore @@ Camlboy.run_instruction camlboy;
    if is_infinite_loop (Camlboy.For_tests.prev_inst camlboy) then
      ()
    else
      loop ()
  in
  loop ()

let%expect_test "01-special.gb" =
  run_test_rom "../../resource/test_roms/blargg/cpu_instrs/individual/01-special.gb";

  [%expect {|
    01-special


    Passed |}]

let%expect_test "02-interrupts.gb" =
  run_test_rom "../../resource/test_roms/blargg/cpu_instrs/individual/02-interrupts.gb";

  [%expect {|
    02-interrupts


    Passed |}]

let%expect_test "03-op sp,hl.gb" =
  run_test_rom "../../resource/test_roms/blargg/cpu_instrs/individual/03-op sp,hl.gb";

  [%expect {|
    03-op sp,hl


    Passed |}]

let%expect_test "04-op r,imm.gb" =
  run_test_rom "../../resource/test_roms/blargg/cpu_instrs/individual/04-op r,imm.gb";

  [%expect {|
    04-op r,imm


    Passed |}]

let%expect_test "05-op rp.gb" =
  run_test_rom "../../resource/test_roms/blargg/cpu_instrs/individual/05-op rp.gb";

  [%expect {|
    05-op rp


    Passed |}]

let%expect_test "06-ld r,r.gb" =
  run_test_rom "../../resource/test_roms/blargg/cpu_instrs/individual/06-ld r,r.gb";

  [%expect {|
    06-ld r,r


    Passed |}]

let%expect_test "07-jr,jp,call,ret,rst.gb" =
  run_test_rom "../../resource/test_roms/blargg/cpu_instrs/individual/07-jr,jp,call,ret,rst.gb";

  [%expect {|
    07-jr,jp,call,ret,rst


    Passed |}]

let%expect_test "08-misc instrs.gb" =
  run_test_rom "../../resource/test_roms/blargg/cpu_instrs/individual/08-misc instrs.gb";

  [%expect {|
    08-misc instrs


    Passed |}]

let%expect_test "09-op r,r.gb" =
  run_test_rom "../../resource/test_roms/blargg/cpu_instrs/individual/09-op r,r.gb";

  [%expect {|
    09-op r,r


    Passed |}]

let%expect_test "10-bit ops.gb" =
  run_test_rom "../../resource/test_roms/blargg/cpu_instrs/individual/10-bit ops.gb";

  [%expect {|
    10-bit ops


    Passed |}]

let%expect_test "11-op a,(hl).gb" =
  run_test_rom "../../resource/test_roms/blargg/cpu_instrs/individual/11-op a,(hl).gb";

  [%expect {|
    11-op a,(hl)


    Passed |}]

let%expect_test "instr_timing.gb" =
  run_test_rom "../../resource/test_roms/blargg/instr_timing/instr_timing.gb";

  [%expect {|
    instr_timing


    Timer doesn't  work properly

    Failed #2 |}]
