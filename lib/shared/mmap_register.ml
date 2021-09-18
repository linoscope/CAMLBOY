open Uints

type t = {
  addr : uint16;
  mutable data : uint8;
  can_read : bool;
  can_write : bool;
}

let create ~addr ~type_ ?(default = Uint8.zero) () =
  match type_ with
  | `RW -> {addr; data = default; can_read = true; can_write = true}
  | `R  -> {addr; data = default; can_read = true; can_write = false}
  | `W  -> {addr; data = default; can_read = false; can_write = true}

let accepts t addr = Uint16.(addr = t.addr)

let read_byte t addr =
  if not @@ t.can_read then
    failwith "cannot read"
  else if not @@ accepts t addr then
    failwith "invalid addr"
  else
    t.data

let write_byte t ~addr ~data =
  if not @@ t.can_read then
    failwith "cannot write"
  else if not @@ accepts t addr then
    failwith "invalid addr"
  else
    t.data <- data

let peek t = t.data
