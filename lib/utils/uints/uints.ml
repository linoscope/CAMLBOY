module MakeInfix (B : Uints_intf.Basics) : Uints_intf.Infix with type t := B.t = struct
  open B
  let ( + ) = add
  let ( - ) = sub
  let ( * ) = mul
  let ( / ) = div
  let ( = ) = equal
  let ( <> ) = (fun a b -> not (equal a b))
  let ( <= ) = le
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

    (* ToDo: Bench mark with polymorphic compare*)
    let compare = Int.compare
    let equal x y = compare x y = 0
    let le x y =
      match compare x y with
      | -1
      |  0 -> true
      |  1 -> false
      | _ -> assert false
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
    let of_char c = Char.code c
    let to_char t = Char.unsafe_chr t
    external to_int : t -> int = "%identity"

    let show = Printf.sprintf "$%02X"
    let pp fmt = Format.fprintf fmt "$%02X"
  end
  include B

  module Infix = MakeInfix(B)
  include Infix
end

module Uint16 = struct
  module B = struct
    type t = int

    let max_int = 0xFFFF
    let zero = 0
    let one = 1

    let compare = Int.compare
    let equal x y = compare x y = 0
    let le x y =
      match compare x y with
      | -1
      |  0 -> true
      |  1 -> false
      | _ -> assert false
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

    let show = Printf.sprintf "$%04X"
    let pp fmt t = Format.fprintf fmt "%s" (show t)
  end
  include B

  module Infix = MakeInfix(B)
  include Infix

  let of_uint8 x = x |> Uint8.to_int |> of_int
  let to_uint8 x = x |> to_int |> Uint8.of_int
end

module Int8 = struct
  type t = int
  let of_byte b = b
  let of_int x =
    if x < 0 then
      (x land 0xFF) lor 0b10000000
    else
      (x land 0xFF)
  let is_neg t = t land (1 lsl 7) <> 0
  let abs t =
    if is_neg t then
      (t - 1) lxor 0b11111111
    else
      t
  let to_int t =
    if is_neg t then
      -(abs t)
    else
      t
  let show t =
    if t land (1 lsl 7) <> 0 then
      Printf.sprintf "-%d" (Int.abs @@ t - 0x100)
    else
      Printf.sprintf "%d" t
  let pp fmt t = Format.fprintf fmt "%s" (show t)
end

type uint8 = Uint8.t
let show_uint8 = Uint8.show
let pp_uint8 = Uint8.pp

type uint16 = Uint16.t
let show_uint16 = Uint16.show
let pp_uint16 = Uint16.pp

type int8 = Int8.t
let show_int8 = Int8.show
let pp_int8 = Int8.pp
