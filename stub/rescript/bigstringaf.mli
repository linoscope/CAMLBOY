type t

val create : int -> t

val unsafe_get : t -> int -> char

val unsafe_set : t -> int -> char -> unit
