open Uints

module type S = sig
  type t

  val read_byte : t -> uint16 -> uint8

  val write_byte : t -> addr:uint16 -> data:uint8 -> unit

  val accepts : t -> addr:uint16 -> bool
end
