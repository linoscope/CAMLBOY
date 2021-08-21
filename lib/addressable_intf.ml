open Uints

module type S = sig
  type t

  val read_byte : t -> uint16 -> uint8

  val write_byte : t -> addr:uint16 -> data:uint8 -> unit

  val read_word : t -> uint16 -> uint16

  val write_word : t -> addr:uint16 -> data:uint16 -> unit
end
