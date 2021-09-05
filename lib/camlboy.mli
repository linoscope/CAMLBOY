type t [@@deriving show]

val show_prev_inst : t -> string

val create : echo_flag:bool -> t

val create_with_rom : echo_flag:bool -> rom_bytes:bytes -> t

val tick : t -> unit
