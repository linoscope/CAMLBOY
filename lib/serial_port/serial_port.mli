type t

val create :
  sb:Mmap_register.t ->
  sc:Mmap_register.t ->
  ?print_serial_port:bool ->
  unit ->
  t

include Addressable_intf.S with type t := t
