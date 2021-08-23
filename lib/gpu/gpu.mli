type t

val create : vram:Ram.t -> oam:Ram.t -> bgp:Mmap_register.t -> t

include Addressable_intf.S with type t := t
