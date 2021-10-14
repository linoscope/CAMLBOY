open Uints

module type S = sig

  type t

  include Addressable_intf.S with type t := t

  val read_word : t -> uint16 -> uint16

  val write_word : t -> addr:uint16 -> data:uint16 -> unit

end
