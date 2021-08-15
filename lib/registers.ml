open Ints

type t = {
  mutable a : uint8;
  mutable b : uint8;
  mutable c : uint8;
  mutable d : uint8;
  mutable e : uint8;
  mutable f : uint8;
  mutable h : uint8;
  mutable l : uint8;
}

type r = A | B | C | D | E | F | H | L

type rr = AF | BC | DE | HL

type flag = Carry | Half_carry | Subtraction | Zero

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
  | AF -> (of_uint8 t.a lsr 8) land of_uint8 t.f
  | BC -> (of_uint8 t.b lsr 8) land of_uint8 t.c
  | DE -> (of_uint8 t.d lsr 8) land of_uint8 t.e
  | HL -> (of_uint8 t.h lsr 8) land of_uint8 t.l


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

let unset_flag t flag =
  let open Uint8 in
  match flag with
  | Carry       -> t.f <- t.f land (of_int 0b11111110)
  | Half_carry  -> t.f <- t.f land (of_int 0b11111101)
  | Subtraction -> t.f <- t.f land (of_int 0b11111011)
  | Zero        -> t.f <- t.f land (of_int 0b11110111)
