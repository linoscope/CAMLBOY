module Make (Gpu : Addressable_intf.S) : sig

  type t

  val create : rom_bytes:bytes -> gpu:Gpu.t -> t

  include Word_addressable_intf.S with type t := t

end
