let f ~rom_bytes =
  let type_ =
    Cartridge_header.create ~rom_bytes
    |> Cartridge_header.get_cartridge_type
  in
  match type_ with
  | Cartridge_type.ROM_ONLY -> (module Rom_only : Cartridge_intf.S)
  | MBC1
  | MBC1_RAM
  | MBC1_RAM_BATTERY        -> (module Mbc1 : Cartridge_intf.S)
  | MBC2
  | MBC2_BATTERY            -> (module Mbc2 : Cartridge_intf.S)
  | other ->
    failwith (Printf.sprintf "Unsupported cartridge type: %s" (Cartridge_type.show other))
