(** @see <https://gbdev.io/pandocs/Tile_Maps.html>  *)

open Uints

type t

type area =
  | Area0
  | Area1

val create :
  area0_start_addr:uint16 ->
  area0_end_addr:uint16 ->
  area1_start_addr:uint16 ->
  area1_end_addr:uint16 ->
  t

val get_tile_index : t -> area:area -> y:int -> x:int -> uint8

include Addressable_intf.S with type t := t
