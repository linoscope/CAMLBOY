open Uints

type t [@@deriving show]

type type_ =
  | VBlank
  | LCD_stat
  | Timer
  | Serial_port
  | Joypad
[@@deriving show]

val create : ie_addr:Uint16.t -> if_addr:Uint16.t -> t

val request : t -> type_ -> unit

val clear : t -> type_ -> unit

(** Returns interrupt that is enabled, requested, and highest priority *)
val next : t -> type_ option

include Addressable_intf.S with type t := t
