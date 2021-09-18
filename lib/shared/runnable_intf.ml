(** Interface for components that run while kept sync with the CPU's machine cycle  *)

module type S = sig

  type t

  (** Run component for [mcycles] machine cycles *)
  val run : t -> mcycles:int -> unit

end
