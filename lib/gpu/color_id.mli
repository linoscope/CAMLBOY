(** Color identifiers used in tile set, etc.
 ** The mapping from this identifier to actual colors is managed in 'pallete.mli' *)

type t =
  | ID_00
  | ID_01
  | ID_10
  | ID_11

val of_bits : hi:bool -> lo:bool -> t

val to_int : t -> int

val set_bit : t -> [`Lo | `Hi] -> t

val clear_bit : t -> [`Lo | `Hi] -> t

val get_bit : t -> [`Lo | `Hi] -> bool
