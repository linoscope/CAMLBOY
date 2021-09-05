open Camlboy_lib

let read_rom_file (rom_file_name : string) : bytes =
  let rom_in = open_in rom_file_name in
  let rom_len = in_channel_length rom_in in
  let rom_bytes = really_input_string rom_in rom_len |> Bytes.of_string in
  rom_bytes

let () =
  let rom_bytes = read_rom_file "./resource/test_roms/blargg/cpu_instrs/individual/01-special.gb" in
  let camlboy = Camlboy.create_with_rom ~rom_bytes ~echo_flag:false in
  while true do
    Printf.printf "%s" (Camlboy.show camlboy);
    Camlboy.tick camlboy;
    Printf.printf " | %s\n" (Camlboy.show_prev_inst camlboy)
  done
