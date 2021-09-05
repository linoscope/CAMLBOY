type t [@@deriving show]

val show_prev_inst : t -> string

val create : unit -> t

val create_with_rom : rom_bytes:bytes -> t

val tick : t -> unit
