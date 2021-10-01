open Uints

type color = [`White | `Light_gray | `Dark_gray | `Black ]

type t = {
  addr : uint16;
  mutable id_00 : color;
  mutable id_01 : color;
  mutable id_10 : color;
  mutable id_11 : color;
}

let create ~addr = {
  addr;
  id_00 = `White;
  id_01 = `Light_gray;
  id_10 = `Dark_gray;
  id_11 = `Black;
}

let lookup t color_id =
  let open Color_id in
  match color_id with
  | ID_00 -> t.id_00
  | ID_01 -> t.id_01
  | ID_10 -> t.id_10
  | ID_11 -> t.id_11

let accepts t addr = Uint16.(addr = t.addr)

let read_byte t addr =
  let bits_of_color = function
    | `White -> 0b00
    | `Light_gray -> 0b01
    | `Dark_gray -> 0b10
    | `Black -> 0b11
  in
  if accepts t addr then
    (bits_of_color t.id_00)
    lor (bits_of_color t.id_01 lsl 2)
    lor (bits_of_color t.id_10 lsl 4)
    lor (bits_of_color t.id_11 lsl 6)
    |> Uint8.of_int
  else
    raise @@ Invalid_argument "Address out of bounds"

let write_byte t ~addr ~data =
  let color_of_bits = function
    | 0b00 -> `White
    | 0b01 -> `Light_gray
    | 0b10 -> `Dark_gray
    | 0b11 -> `Black
    | _    -> assert false
  in
  let data = Uint8.to_int data in
  if accepts t addr then begin
    t.id_00 <- color_of_bits @@ data land 0b00000011;
    t.id_01 <- color_of_bits @@ (data land 0b00001100) lsr 2;
    t.id_10 <- color_of_bits @@ (data land 0b00110000) lsr 4;
    t.id_11 <- color_of_bits @@ (data land 0b11000000) lsr 6;
  end else
    raise @@ Invalid_argument "Address out of bounds"
