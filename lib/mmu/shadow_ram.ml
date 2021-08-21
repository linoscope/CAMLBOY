open Uints

type t = {
  target : Ram.t;
  target_start : uint16;
  shadow_start : uint16;
  shadow_end : uint16;
}

let create ~target ~target_start ~shadow_start ~shadow_end = {
  target;
  target_start;
  shadow_start;
  shadow_end;
}

(* raise @@ Invalid_argument (Printf.sprintf "Address out of range: %s" (Uint16.show addr)) *)

let accepts t ~addr =
  Uint16.(t.shadow_start <= addr && addr <= t.shadow_end)

let read_byte t addr =
  if accepts t ~addr then begin
    let open Uint16 in
    let offset = addr - t.shadow_start in
    Ram.read_byte t.target (t.target_start + offset)
  end else
    raise @@ Invalid_argument (Printf.sprintf "Address out of range: %s" (Uint16.show addr))

let write_byte _ ~addr ~data =
  failwith @@
  Printf.sprintf "Write to shadow ram not allowed. addr:%s, data:%s"
    (Uint16.show addr) (Uint8.show data)
