type t

val create :
  rom:Rom.t ->
  wram:Ram.t ->
  gpu:Gpu.t ->
  zero_page:Ram.t ->
  shadow_ram:Shadow_ram.t ->
  serial_port:Serial_port.t ->
  t

include Word_addressable.S with type t := t
