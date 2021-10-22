open Camlboy_lib

let create file =
  let rom_bytes = Read_rom_file.f file in
  Cartridge_header.create ~rom_bytes

let%expect_test "test rom only" =
  let t = create "../../resource/test_roms/hello.gb" in

  t
  |> Cartridge_header.get_cartridge_type
  |> Cartridge_type.show
  |> print_endline;

  t
  |> Cartridge_header.get_rom_bank_count
  |> Printf.printf "%d\n";

  t
  |> Cartridge_header.get_ram_bank_count
  |> Printf.printf "%d\n";

  [%expect {|
    Cartridge_type.ROM_ONLY
    2
    0 |}]

let%expect_test "test mbc1" =
  let t = create "../../resource/test_roms/blargg/cpu_instrs/cpu_instrs.gb" in

  t
  |> Cartridge_header.get_cartridge_type
  |> Cartridge_type.show
  |> print_endline;

  t
  |> Cartridge_header.get_rom_bank_count
  |> Printf.printf "%d\n";

  t
  |> Cartridge_header.get_ram_bank_count
  |> Printf.printf "%d\n";

  [%expect {|
    Cartridge_type.MBC1
    4
    1 |}]
