(** A 16 bit memory bus, which is used by the CPU to address ROM, RAM, and I/O.
 ** It is often refered to as the "MMU" in documentation/emulator code,
 ** but that is a little inacurate since the Game Boy does not have a dedicated memory management unit. *)

module Make (Cartridge : Addressable_intf.S) : sig

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
    dma_transfer:Mmap_register.t ->
    t

  include Word_addressable_intf.S with type t := t

end
