(* open Camlboy_lib
 * include Testing_utils
 *
 * let%expect_test "01-special.gb" =
 *   let rom_bytes = read_rom_file "../resource/test_roms/blargg/cpu_instrs/individual/01-special.gb" in
 *   let rom_len = Bytes.length rom_bytes in
 *   Printf.printf "rom size: 0x%x\n" rom_len;
 *   let camlboy = Camlboy.create_with_rom ~rom_bytes in
 *   let rec loop () =
 *     Camlboy.tick camlboy;
 *     Printf.printf "%s\n" (Camlboy.show camlboy);
 *     loop ();
 *   in
 *   loop () *)
