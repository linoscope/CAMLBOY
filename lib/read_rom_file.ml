
let f (rom_file_name : string) : bytes =
  let rom_in = open_in rom_file_name in
  let rom_len = in_channel_length rom_in in
  let rom_bytes = really_input_string rom_in rom_len |> Bytes.of_string in
  rom_bytes
