module type Basics = sig
  type t

  val show : t -> string

  val max_int : t
  val zero : t
  val one : t

  val compare : t -> t -> int
  val equal : t -> t -> bool
  val le : t -> t -> bool
  val add : t -> t -> t
  val sub : t -> t -> t
  val mul : t -> t -> t
  val div : t -> t -> t
  val rem : t -> t -> t
  val succ : t -> t
  val pred : t -> t
  val logand : t -> t -> t
  val logor : t -> t -> t
  val logxor : t -> t -> t
  val shift_left : t -> int -> t
  val shift_right : t -> int -> t
  val of_int : int -> t
  val to_int : t -> int
end

module type Infix = sig
  type t

  val ( + ) : t -> t -> t
  val ( - ) : t -> t -> t
  val ( * ) : t -> t -> t
  val ( / ) : t -> t -> t
  val ( = ) : t -> t -> bool
  val ( <> ) : t -> t -> bool
  val ( <= ) : t -> t -> bool
  val ( mod ) : t -> t -> t
  val ( land ) : t -> t -> t
  val ( lor ) : t -> t -> t
  val ( lxor ) : t -> t -> t
  val ( lsl ) : t -> int -> t
  val ( lsr ) : t -> int -> t
end

module type S = sig
  type t

  include Basics with type t := t
  module Infix : Infix with type t := t
  include Infix with type t := t
end
