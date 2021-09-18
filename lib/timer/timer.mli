open Uints

type t

val create :
  div_addr:uint16
  -> tima_addr:uint16
  -> tma_addr:uint16
  -> tac_addr:uint16
  -> ic:Interrupt_controller.t
  -> t

val run : t -> mcycles:int -> unit

include Addressable_intf.S with type t := t
