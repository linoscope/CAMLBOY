type t = {
  vram : bytes;
}

let create () = {
  vram = Bytes.create (0x9FFF - 0x8000)
}

let read_byte _ _ = assert false

let write_byte _ ~addr:_ ~data:_ = assert false
