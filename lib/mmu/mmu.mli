type t

val create :
  cartridge:Cartridge.t ->
  wram:Ram.t ->
  gpu:Gpu.t ->
  zero_page:Ram.t ->
  shadow_ram:Shadow_ram.t ->
  joypad:Joypad.t ->
  serial_port:Serial_port.t ->
  ic:Interrupt_controller.t ->
  timer:Timer.t ->
  t

include Word_addressable.S with type t := t
