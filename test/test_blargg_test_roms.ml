open Camlboy_lib
open Uints
include Testing_utils

let run_test_rom file ~until =
  let rom_bytes = read_rom_file file  in
  let camlboy = Camlboy.create_with_rom ~rom_bytes ~echo_flag:true in
  let rec loop () =
    Camlboy.tick camlboy;
    if Uint16.(Camlboy.For_tests.current_pc camlboy = of_int until) then
      ()
    else
      loop ()
  in
  loop ()

let%expect_test "01-special.gb" =
  run_test_rom "../resource/test_roms/blargg/cpu_instrs/individual/01-special.gb" ~until:0xC7D2;

  [%expect {|
    01-special

    256C6C48
    DAA

    Failed #6 |}]
