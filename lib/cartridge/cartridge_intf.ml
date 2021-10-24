module type S = sig

  type t

  val create : rom_bytes:Bigstringaf.t -> t

  include Addressable_intf.S with type t := t

end
