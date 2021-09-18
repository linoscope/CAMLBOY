open Uints

type t

val create :
  vram:Ram.t
  -> oam:Ram.t
  -> bgp:Mmap_register.t
  -> ly_addr:uint16
  -> ic:Interrupt_controller.t
  -> t

include Synced_intf.S with type t := t

include Addressable_intf.S with type t := t
