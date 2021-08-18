open Ints

type t [@@deriving show]

val create : size:int -> t

val load : t -> src:bytes -> dst_pos:uint16 -> unit

val read_byte : t -> uint16 -> uint8

val read_word : t -> uint16 -> uint16

val write_byte : t -> addr:uint16 -> data:uint8 -> unit

val write_word : t -> addr:uint16 -> data:uint16 -> unit
