open Uints

type t = {
  mutable byte : uint8;
  addr : uint16;
}

let create ~addr = {
  byte = Uint8.of_int 0xEF;
  addr;
}

let accepts t addr = addr = t.addr

let read_byte t addr =
  if addr = t.addr then
    t.byte
  else
    raise @@ Invalid_argument (Printf.sprintf "Address out of range: %s" (Uint16.show addr))

let write_byte t ~addr ~data:_ =
  if addr = t.addr then
    ()
  else
    raise @@ Invalid_argument (Printf.sprintf "Address out of range: %s" (Uint16.show addr))
