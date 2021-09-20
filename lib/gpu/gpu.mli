type t

val create :
  vram:Ram.t
  -> oam:Ram.t
  -> bgp:Pallete.t
  -> lcd_stat:Lcd_stat.t
  -> lcd_control:Lcd_control.t
  -> lcd_position:Lcd_position.t
  -> ic:Interrupt_controller.t
  -> t

include Runnable_intf.S with type t := t

include Addressable_intf.S with type t := t
