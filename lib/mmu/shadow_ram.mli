open Uints

type t

val create :
  target:Ram.t ->
  target_start:uint16 ->
  shadow_start:uint16 ->
  shadow_end:uint16 ->
  t

include Addressable_intf.S with type t := t
