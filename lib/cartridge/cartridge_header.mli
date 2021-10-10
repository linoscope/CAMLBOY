
type t

val create : rom_bytes:bytes -> t

val get_cartridge_type : t -> [`ROM_ONLY | `NO_MBC | `MBC1]

val get_rom_bank_count : t -> int

val get_ram_bank_count : t -> int
