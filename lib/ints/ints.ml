module MakeInfix (B : Ints_intf.Basics) : Ints_intf.Infix with type t := B.t = struct
  open B
  let ( + ) = add
  let ( - ) = sub
  let ( * ) = mul
  let ( / ) = div
  let ( mod ) = rem
  let ( land ) = logand
  let ( lor ) = logor
  let ( lxor ) = logxor
  let ( lsl ) = shift_left
  let ( lsr ) = shift_right
end

let make_basics_module (max_int : int) : (module Ints_intf.Basics) = (module struct
  type t = int

  let max_int = max_int
  let zero = 0
  let one = 1

  let compare = compare
  let add x y = (x + y) land max_int
  let sub x y = (x - y) land max_int
  let mul x y = (x * y) land max_int
  let div x y = (x / y) land max_int
  let rem x y = (x mod y) land max_int
  let succ x = add x one
  let pred x = sub x one
  let logand x y = (x land y)
  let logor x y = (x lor y)
  let logxor = (lxor)
  let shift_left x y = (x lsl y) land max_int
  let shift_right = (lsr)
  let of_int x = x land max_int
  external to_int : t -> int = "%identity"

  let to_string = Int.to_string
  let to_hexstring x = Printf.sprintf "0x%x" x
  let pp fmt x = Format.fprintf fmt "%s" (to_string x)
  let pp_hex fmt x = Format.fprintf fmt "%s" (to_hexstring x)
end : Ints_intf.Basics)

module Uint8 = struct
  module B = (val make_basics_module 0xff : Ints_intf.Basics)
  include B

  module Infix = MakeInfix(B)
  include Infix
end

module Uint16 = struct
  module B = (val make_basics_module 0xffff : Ints_intf.Basics)
  include B

  module Infix = MakeInfix(B)
  include Infix

  let of_uint8 x = x |> Uint8.to_int |> of_int
end

type uint8 = Uint8.t

type uint16 = Uint16.t
