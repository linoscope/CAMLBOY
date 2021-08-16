open Ints

let f ~rom_file ~out  =
  let rom_in = open_in rom_file in
  let rom_len = in_channel_length rom_in in
  let rom_bytes = really_input_string rom_in rom_len |> Bytes.of_string in

  let memory = Memory.create () in
  Memory.load memory ~src:rom_bytes ~dst_pos:Uint16.zero;

  let rom_len = rom_len |> Uint16.of_int in
  let rec loop pc =
    if pc == rom_len then
      ()
    else
      let (inst_len, inst) = Instruction.fetch memory ~pc in
      Instruction.show inst |> Printf.fprintf out "%s\n";
      loop Uint16.(pc + inst_len)
  in

  loop Uint16.zero
