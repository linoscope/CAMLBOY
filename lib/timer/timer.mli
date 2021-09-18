open Uints

type t

val create :
  div_addr:uint16
  -> tima_addr:uint16
  -> tma_addr:uint16
  -> tac_addr:uint16
  -> ic:Interrupt_controller.t
  -> t

include Runnable_intf.S with type t := t

include Addressable_intf.S with type t := t
