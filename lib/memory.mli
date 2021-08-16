open Ints

type t

val create : unit -> t

val load : t -> src:bytes -> dst_pos:uint16 -> unit

val read_byte : t -> uint16 -> uint8

val read_word : t -> uint16 -> uint16
