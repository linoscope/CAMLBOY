open Uints

type t = {
  vram : Ram.t;
  oam : Ram.t;
}

let create ~vram ~oam = { vram; oam }

let read_byte t addr =
  match addr with
  | _ when Ram.accepts t.vram ~addr -> Ram.read_byte t.vram addr
  | _ when Ram.accepts t.oam  ~addr -> Ram.read_byte t.oam addr
  | _ -> raise @@ Invalid_argument (Printf.sprintf "Address out of range: %s" (Uint16.show addr))

let write_byte t ~addr ~data =
  match addr with
  | _ when Ram.accepts t.vram ~addr -> Ram.write_byte t.vram ~addr ~data
  | _ when Ram.accepts t.oam  ~addr -> Ram.write_byte t.oam ~addr ~data
  | _ -> raise @@ Invalid_argument (Printf.sprintf "Address out of range: %s" (Uint16.show addr))


let accepts t ~addr = Ram.accepts t.vram ~addr || Ram.accepts t.oam ~addr
