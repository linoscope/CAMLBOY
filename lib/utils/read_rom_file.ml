let f (rom_file_name : string) =
  let rom_in = open_in rom_file_name in
  let rom_len = in_channel_length rom_in in
  let rom_string = really_input_string rom_in rom_len in
  Bigstringaf.of_string ~off:0 ~len:rom_len rom_string
