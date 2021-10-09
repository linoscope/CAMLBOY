
type t

val create : rom_bytes:bytes -> t

val get_cartridge_type : t -> [`ROM_ONLY | `MBC1]
