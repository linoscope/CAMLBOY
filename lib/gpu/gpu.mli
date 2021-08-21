type t

val create : unit -> t

include Addressable_intf.S with type t := t
