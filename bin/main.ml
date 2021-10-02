open Camlboy_lib

let () =
  let rom_bytes = Read_rom_file.f "./resource/test_roms/hello.gb" in
  let camlboy = Camlboy.create_with_rom ~rom_bytes ~echo_flag:false in
  while true do
    Printf.printf "%s" (Camlboy.show camlboy);
    Printf.printf " LY:%d" (Camlboy.For_tests.get_ly camlboy);
    Printf.printf " LCD_STAT:%s" (Camlboy.For_tests.get_lcd_stat camlboy |> Uints.Uint8.show);
    Printf.printf " MC:%3d" (Camlboy.For_tests.get_mcycles_in_mode camlboy);
    Camlboy.run_instruction camlboy;
    Printf.printf " | %s\n" (Camlboy.For_tests.prev_inst camlboy |> Instruction.show);
  done
