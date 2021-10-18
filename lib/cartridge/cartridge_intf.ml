open Uints

module type S = sig

  type t

  val create :
    rom_bytes:bytes ->
    rom_bank0_start_addr:uint16 ->
    rom_bank0_end_addr:uint16 ->
    rom_bank_start_addr:uint16 ->
    rom_bank_end_addr:uint16 ->
    ram_bank_start_addr:uint16 ->
    ram_bank_end_addr:uint16 ->
    t

  include Addressable_intf.S with type t := t

end
