open Uints

type t

val create :
  tima_addr:uint16
  -> tma_addr:uint16
  -> tac_addr:uint16
  -> ic:Interrupt_controller.t
  -> t

include Synced_intf.S with type t := t

include Addressable_intf.S with type t := t
