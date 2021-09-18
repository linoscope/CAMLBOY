(** Interface for components in which we can read/write bytes  *)

open Uints

module type S = sig

  type t

  val read_byte : t -> uint16 -> uint8

  val write_byte : t -> addr:uint16 -> data:uint8 -> unit

  val accepts : t -> uint16 -> bool

end
