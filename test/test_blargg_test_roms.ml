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

    24B700C8
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

    93 DB C9 C9 48 48 C8 C8
    Failed |}]

let%expect_test "04-op r,imm.gb" =
  run_test_rom "../resource/test_roms/blargg/cpu_instrs/individual/04-op r,imm.gb";

  [%expect {|
    04-op r,imm

    B6 36 7E B6 FE 36 7E FE B6 FE 36 7E B6 FE 36 7E
    Failed |}]

let%expect_test "05-op rp.gb" =
  run_test_rom "../resource/test_roms/blargg/cpu_instrs/individual/05-op rp.gb";

  [%expect {|
    05-op rp

    5B DB 5B 13 93 13 49 C9 49
    Failed |}]

let%expect_test "06-ld r,r.gb" =
  run_test_rom "../resource/test_roms/blargg/cpu_instrs/individual/06-ld r,r.gb";

  [%expect {|
    06-ld r,r

    00 01 12 13 24 25 36 37 48 49 5A 5B 6C 6D 7E 7F 80 81 92 93 A4 A5 B6 B7 C8 C9 DA DB EC ED FE FF 00 01 12 13 24 25 36 37 48 49 5A 5B 6C 6D 7E 7F 80 81 92 93 A4 A5 B7 C8 C9 DA DB EC ED FE FF
    Failed |}]

let%expect_test "07-jr,jp,call,ret,rst.gb" =
  run_test_rom "../resource/test_roms/blargg/cpu_instrs/individual/07-jr,jp,call,ret,rst.gb";

  [%expect {|
    07-jr,jp,call,ret,rst

    C8 00 48 80 C8 12 13 5A 92 DA 24 6C 6D A4 EC 00 48 49 80 C8 C9 37 7F B7 FF 37 7F B7 FF
    Failed |}]

let%expect_test "08-misc instrs.gb" =
  run_test_rom "../resource/test_roms/blargg/cpu_instrs/individual/08-misc instrs.gb";

  [%expect {|
    08-misc instrs

    80 00 92 12 DA 5A 48 01 81 01 81 A5 25 A5 25 81 01 81 01
    Failed |}]

let%expect_test "09-op r,r.gb" =
  run_test_rom "../resource/test_roms/blargg/cpu_instrs/individual/09-op r,r.gb";

  [%expect {|
    09-op r,r

    00 7F B7 FF 80 81 92 93 A4 A5 B7 C8 C9 DA DB EC ED FF 00 01 12 13 24 25 37 48 49 5A 5B 6C 6D 7F 80 81 92 93 A4 A5 B7 C8 C9 DA DB EC ED FF 00 01 12 13 24 25 37 48 49 5A 5B 6C 6D 7F 25 6D A5 ED 25 6D ED 24 6C A4 EC 24 6C EC 37 B7 7F FF 5B 00 5B 01 5B 12 5B 13 5B 24 5B 25 5B 37 5B 48 5B 49 5B 5A 5B 5B 5B 6C 5B 6D 5B 7F 5B 80 5B 81 5B 92 5B 93 5B A4 5B A5 5B B7 5B C8 5B C9 5B DA 5B DB 5B EC 5B ED 5B FF 5B 00 5B 01 5B 12 5B 13 5B 24 5B 25 5B 37 5B 48 5B 49 5B 5A 5B 5B 5B 6C 5B 6D 5B 7F 5B 80 5B 81 5B 92 5B 93 5B A4 5B A5 5B B7 5B C8 5B C9 5B DA 5B DB 5B EC 5B ED 5B FF
    Failed |}]
