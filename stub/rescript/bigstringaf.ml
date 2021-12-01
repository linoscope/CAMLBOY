open Js.Typed_array

type t = Uint8Array.t

let create size = Uint8Array.fromLength size

let unsafe_get t i = Uint8Array.unsafe_get t i |> Char.unsafe_chr

let unsafe_set t i data = Uint8Array.unsafe_set t i (Char.code data)
