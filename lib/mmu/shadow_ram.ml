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

let accepts t addr =
  Uint16.(t.shadow_start <= addr && addr <= t.shadow_end)

let read_byte t addr =
  if not @@ accepts t addr then
    raise @@ Invalid_argument (Printf.sprintf "Address out of range: %s" (Uint16.show addr))
  else begin
    let open Uint16 in
    let offset = addr - t.shadow_start in
    Ram.read_byte t.target (t.target_start + offset)
  end

let write_byte t ~addr ~data =
  if not @@ accepts t addr then
    raise @@ Invalid_argument (Printf.sprintf "Address out of range: %s" (Uint16.show addr))
  else begin
    let open Uint16 in
    let offset = addr - t.shadow_start in
    Ram.write_byte t.target ~addr:(t.target_start + offset) ~data
  end
