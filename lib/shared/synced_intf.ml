(** Interface for components that need to be synced with the CPU mcycle  *)

module type S = sig

  type t

  (** Run component for [mcycles] machine cycles *)
  val run : t -> mcycles:int -> unit

end
