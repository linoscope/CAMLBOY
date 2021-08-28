type t [@@deriving show]

val create : unit -> t

val tick : t -> unit
