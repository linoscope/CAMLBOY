open Uints

type t [@@deriving show]

val create : echo_flag:bool -> t

val create_with_rom : echo_flag:bool -> rom_bytes:bytes -> t

val tick : t -> unit

module For_tests : sig

  val show_prev_inst : t -> string

  val current_pc : t -> uint16

end
