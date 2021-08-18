module Uint8 : Uints_intf.S

module Uint16 : sig
  include Uints_intf.S
  val of_uint8 : Uint8.t -> t
end

type uint8 = Uint8.t [@@deriving show]

type uint16 = Uint16.t [@@deriving show]
