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

module Uint8 = struct
  module B = struct
    type t = int

    let max_int = 0xFF
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

    let show = Printf.sprintf "0x%02x"
    let pp fmt = Format.fprintf fmt "0x%02x"
  end
  include B
  (* let show = Printf.sprintf "0x%02x"
   * let pp fmt = Format.fprintf fmt "0x%02x" *)

  module Infix = MakeInfix(B)
  include Infix
end

module Uint16 = struct
  module B = struct
    type t = int

    let max_int = 0xFFFF
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

    let show = Printf.sprintf "0x%04x"
    let pp fmt t = Format.fprintf fmt "%s" (show t)
  end
  include B

  module Infix = MakeInfix(B)
  include Infix

  let of_uint8 x = x |> Uint8.to_int |> of_int
end

type uint8 = Uint8.t
let show_uint8 = Uint8.show
let pp_uint8 = Uint8.pp

type uint16 = Uint16.t
let show_uint16 = Uint16.show
let pp_uint16 = Uint16.pp
