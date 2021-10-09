open Camlboy_lib

let create file =
  let rom_bytes = Read_rom_file.f file in
  Cartridge_header.create ~rom_bytes

let show_cartridge_type = function
  | `ROM_ONLY -> "ROM_ONLY"
  | `MBC1     -> "MBC1"

let%expect_test "test rom only" =
  let t = create "../../resource/test_roms/hello.gb" in

  t
  |> Cartridge_header.get_cartridge_type
  |> show_cartridge_type
  |> print_endline;

  [%expect {| ROM_ONLY |}]

let%expect_test "test mbc1" =
  let t = create "../../resource/test_roms/blargg/cpu_instrs/cpu_instrs.gb" in

  t
  |> Cartridge_header.get_cartridge_type
  |> show_cartridge_type
  |> print_endline;

  [%expect {| MBC1 |}]
