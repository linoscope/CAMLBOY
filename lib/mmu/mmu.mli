module Make (Gpu : Addressable_intf.S) : sig

  type t

  val create : gpu:Gpu.t -> t

  val load_rom : t -> rom:bytes -> unit

  include Word_addressable_intf.S with type t := t

end
