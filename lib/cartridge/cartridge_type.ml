type t =
  | ROM_ONLY
  | MBC1
  | MBC1_RAM
  | MBC1_RAM_BATTERY
  | MBC2
  | MBC2_BATTERY
  | MBC3_TIMER_BATTERY
  | MBC3_TIMER_RAM_BATTERY
  | MBC3

let show = function
  | ROM_ONLY               -> "ROM_ONLY"
  | MBC1                   -> "MBC1"
  | MBC1_RAM               -> "MBC1_RAM"
  | MBC1_RAM_BATTERY       -> "MBC1_RAM_BATTERY"
  | MBC2                   -> "MBC2"
  | MBC2_BATTERY           -> "MBC2_BATTERY"
  | MBC3_TIMER_BATTERY     -> "MBC3_TIMER_BATTERY"
  | MBC3_TIMER_RAM_BATTERY -> "MBC3_TIMER_RAM_BATTERY"
  | MBC3                   -> "MBC3"
