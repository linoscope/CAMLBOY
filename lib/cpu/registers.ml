open Uints

let pp_f fmt f =
  let f = Uint8.to_int f in
  let c = if f land 0b0001 <> 0 then 1 else 0 in
  let h = if f land 0b0010 <> 0 then 1 else 0 in
  let n = if f land 0b0100 <> 0 then 1 else 0 in
  let z = if f land 0b1000 <> 0 then 1 else 0 in
  Format.fprintf fmt "(c=%d, h=%d, n=%d, z=%d)" c h n z

type t = {
  mutable a : uint8;
  mutable b : uint8;
  mutable c : uint8;
  mutable d : uint8;
  mutable e : uint8;
  mutable f : uint8 [@printer pp_f];
  mutable h : uint8;
  mutable l : uint8;
}
[@@deriving show]

type r =
  | A [@printer fun fmt _ -> fprintf fmt "A"]
  | B [@printer fun fmt _ -> fprintf fmt "B"]
  | C [@printer fun fmt _ -> fprintf fmt "C"]
  | D [@printer fun fmt _ -> fprintf fmt "D"]
  | E [@printer fun fmt _ -> fprintf fmt "E"]
  | F [@printer fun fmt _ -> fprintf fmt "F"]
  | H [@printer fun fmt _ -> fprintf fmt "H"]
  | L [@printer fun fmt _ -> fprintf fmt "L"]
[@@deriving show]

type rr =
  | AF [@printer fun fmt _ -> fprintf fmt "AF"]
  | BC [@printer fun fmt _ -> fprintf fmt "BC"]
  | DE [@printer fun fmt _ -> fprintf fmt "DE"]
  | HL [@printer fun fmt _ -> fprintf fmt "HL"]
[@@deriving show]

type flag = Carry | Half_carry | Subtraction | Zero

let create () = {
  a = Uint8.zero;
  b = Uint8.zero;
  c = Uint8.zero;
  d = Uint8.zero;
  e = Uint8.zero;
  f = Uint8.zero;
  h = Uint8.zero;
  l = Uint8.zero;
}

let read_r t = function
  | A -> t.a
  | B -> t.b
  | C -> t.c
  | D -> t.d
  | E -> t.e
  | F -> t.f
  | H -> t.h
  | L -> t.l

let read_rr t rr =
  let open Uint16 in
  match rr with
  | AF -> (of_uint8 t.a lsl 8) lor of_uint8 t.f
  | BC -> (of_uint8 t.b lsl 8) lor of_uint8 t.c
  | DE -> (of_uint8 t.d lsl 8) lor of_uint8 t.e
  | HL -> (of_uint8 t.h lsl 8) lor of_uint8 t.l

let write_r t r x = match r with
  | A -> t.a <- x
  | B -> t.b <- x
  | C -> t.c <- x
  | D -> t.d <- x
  | E -> t.e <- x
  | F -> t.f <- x
  | H -> t.h <- x
  | L -> t.l <- x

let write_rr t rr x =
  let x = Uint16.to_int x in
  let high = (x land 0xFF00) lsr 8 |> Uint8.of_int in
  let low  =  x land 0x00FF        |> Uint8.of_int in
  match rr with
  | AF -> t.a <- high; t.f <- low
  | BC -> t.b <- high; t.c <- low
  | DE -> t.d <- high; t.e <- low
  | HL -> t.h <- high; t.l <- low

let read_flag t flag =
  let f = t.f |> Uint8.to_int in
  match flag with
  | Carry       -> f land 0b0001 <> 0
  | Half_carry  -> f land 0b0010 <> 0
  | Subtraction -> f land 0b0100 <> 0
  | Zero        -> f land 0b1000 <> 0

let set_flag t flag =
  let open Uint8 in
  match flag with
  | Carry       -> t.f <- t.f lor (of_int 0b0001)
  | Half_carry  -> t.f <- t.f lor (of_int 0b0010)
  | Subtraction -> t.f <- t.f lor (of_int 0b0100)
  | Zero        -> t.f <- t.f lor (of_int 0b1000)

let set_flags t
    ?(c = read_flag t Carry)
    ?(h = read_flag t Half_carry)
    ?(n = read_flag t Subtraction)
    ?(z = read_flag t Zero)
    () =
  let open Uint8 in
  if c then t.f <- t.f lor (of_int 0b0001) else t.f <- t.f land (of_int 0b1110);
  if h then t.f <- t.f lor (of_int 0b0010) else t.f <- t.f land (of_int 0b1101);
  if n then t.f <- t.f lor (of_int 0b0100) else t.f <- t.f land (of_int 0b1011);
  if z then t.f <- t.f lor (of_int 0b1000) else t.f <- t.f land (of_int 0b0111)

let unset_flag t flag =
  let open Uint8 in
  match flag with
  | Carry       -> t.f <- t.f land (of_int 0b11111110)
  | Half_carry  -> t.f <- t.f land (of_int 0b11111101)
  | Subtraction -> t.f <- t.f land (of_int 0b11111011)
  | Zero        -> t.f <- t.f land (of_int 0b11110111)

let clear_flags t = t.f <- Uint8.zero
