open Uints

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

type flag =
  | Carry                       (* c *)
  | Half_carry                  (* h *)
  | Subtraction                 (* n *)
  | Zero                        (* z *)

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
  | F ->
    (* Bottom 4 bits of the flag register is always zero *)
    t.f <- Uint8.(x land of_int 0xF0)
  | H -> t.h <- x
  | L -> t.l <- x

let write_rr t rr x =
  let x = Uint16.to_int x in
  let high = (x land 0xFF00) lsr 8 |> Uint8.of_int in
  let low  =  x land 0x00FF        |> Uint8.of_int in
  match rr with
  | AF ->
    t.a <- high;
    (* Bottom 4 bits of the flag register is always zero *)
    t.f <- Uint8.(low land of_int 0xF0)
  | BC -> t.b <- high; t.c <- low
  | DE -> t.d <- high; t.e <- low
  | HL -> t.h <- high; t.l <- low

let read_flag t flag =
  let f = t.f |> Uint8.to_int in
  match flag with
  | Carry       -> f land 0b00010000 <> 0
  | Half_carry  -> f land 0b00100000 <> 0
  | Subtraction -> f land 0b01000000 <> 0
  | Zero        -> f land 0b10000000 <> 0

(* Precompute uint8 masks to reduce calls to Uint8.of_int.
 * Improves performance of whole emulator by ~1% *)
let mask_0b00010000 = Uint8.of_int 0b00010000
let mask_0b11100000 = Uint8.of_int 0b11100000
let mask_0b00100000 = Uint8.of_int 0b00100000
let mask_0b11010000 = Uint8.of_int 0b11010000
let mask_0b01000000 = Uint8.of_int 0b01000000
let mask_0b10110000 = Uint8.of_int 0b10110000
let mask_0b10000000 = Uint8.of_int 0b10000000
let mask_0b01110000 = Uint8.of_int 0b01110000
let mask_0b11101111 = Uint8.of_int 0b11101111
let mask_0b11011111 = Uint8.of_int 0b11011111
let mask_0b10111111 = Uint8.of_int 0b10111111
let mask_0b01111111 = Uint8.of_int 0b01111111

let set_flag t flag =
  let open Uint8 in
  match flag with
  | Carry       -> t.f <- t.f lor mask_0b00010000
  | Half_carry  -> t.f <- t.f lor mask_0b00100000
  | Subtraction -> t.f <- t.f lor mask_0b01000000
  | Zero        -> t.f <- t.f lor mask_0b10000000

let set_flags t
    ?(c = read_flag t Carry)
    ?(h = read_flag t Half_carry)
    ?(n = read_flag t Subtraction)
    ?(z = read_flag t Zero)
    () =
  let open Uint8 in
  if c then t.f <- t.f lor mask_0b00010000 else t.f <- t.f land mask_0b11100000;
  if h then t.f <- t.f lor mask_0b00100000 else t.f <- t.f land mask_0b11010000;
  if n then t.f <- t.f lor mask_0b01000000 else t.f <- t.f land mask_0b10110000;
  if z then t.f <- t.f lor mask_0b10000000 else t.f <- t.f land mask_0b01110000

let unset_flag t flag =
  let open Uint8 in
  match flag with
  | Carry       -> t.f <- t.f land mask_0b11101111
  | Half_carry  -> t.f <- t.f land mask_0b11011111
  | Subtraction -> t.f <- t.f land mask_0b10111111
  | Zero        -> t.f <- t.f land mask_0b01111111

let clear_flags t = t.f <- Uint8.zero

let show_f f =
  let f = Uint8.to_int f in
  let z = if f land 0b10000000 <> 0 then 'Z' else '-' in
  let n = if f land 0b01000000 <> 0 then 'N' else '-' in
  let h = if f land 0b00100000 <> 0 then 'H' else '-' in
  let c = if f land 0b00010000 <> 0 then 'C' else '-' in
  Printf.sprintf "%c%c%c%c" z n h c

(* A:$11 F:Z-HC BC:$0013 DE:$00D8 $HL:014D  *)
let show t =
  Printf.sprintf "A:%s F:%s BC:%s DE:%s HL:%s"
    (read_r t A |> Uint8.show)
    (show_f t.f)
    (read_rr t BC |> Uint16.show)
    (read_rr t DE |> Uint16.show)
    (read_rr t HL |> Uint16.show)

let pp fmt t = Format.fprintf fmt "%s" (show t)

