let f = function
  | Cartridge_type.ROM_ONLY -> (module Cartridge_rom_only : Cartridge_intf.S)
  | MBC1
  | MBC1_RAM
  | MBC1_RAM_BATTERY        -> (module Cartridge_mbc1 : Cartridge_intf.S)
  | _                       -> assert false
