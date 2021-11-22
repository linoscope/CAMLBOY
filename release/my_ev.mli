open Brr

module Touch : sig
  type t

  module Touch' : sig
    type t
    val identifier : t -> int
    val client_x : t -> float
    val client_y : t -> float
    val page_x : t -> float
    val page_y : t -> float
    val screen_x : t -> float
    val screen_y : t -> float
  end

  val alt_key : t -> bool
  val ctrl_key : t -> bool
  val shift_key : t -> bool
  val meta_key : t -> bool
end

val touchstart : Touch.t Ev.type'
val touchend : Touch.t Ev.type'
