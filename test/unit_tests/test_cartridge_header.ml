open Camlboy_lib

let f (rom_file_name : string) =
  let rom_in = open_in rom_file_name in
  let rom_len = in_channel_length rom_in in
  let rom_string = really_input_string rom_in rom_len in
  Bigstringaf.of_string ~off:0 ~len:rom_len rom_string

let create file =
  let rom_bytes = f file in
  Cartridge_header2.create ~rom_bytes

let%expect_test "test rom only" =
  let t = create "../../resource/test_roms/hello.gb" in

  t
  |> Cartridge_header2.get_cartridge_type
  |> Cartridge_type.show
  |> print_endline;

  t
  |> Cartridge_header2.get_rom_bank_count
  |> Printf.printf "%d\n";

  t
  |> Cartridge_header2.get_ram_bank_count
  |> Printf.printf "%d\n";

  [%expect {|
    Cartridge_type.ROM_ONLY
    2
    0 |}]

let%expect_test "test mbc1" =
  let t = create "../../resource/test_roms/blargg/cpu_instrs/cpu_instrs.gb" in

  t
  |> Cartridge_header2.get_cartridge_type
  |> Cartridge_type.show
  |> print_endline;

  t
  |> Cartridge_header2.get_rom_bank_count
  |> Printf.printf "%d\n";

  t
  |> Cartridge_header2.get_ram_bank_count
  |> Printf.printf "%d\n";

  [%expect {|
    Cartridge_type.MBC1
    4
    0 |}]
