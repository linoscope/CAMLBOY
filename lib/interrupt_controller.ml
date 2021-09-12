open Uints

type state = {
  mutable enabled : bool;
  mutable requested : bool;
}

(* TODO: represent flags using bits like t = { ie : int; if_: int }  *)
type t = {
  vblank : state;
  lcd_stat : state;
  timer : state;
  serial_port : state;
  joypad : state;
  ie_addr : Uint16.t;
  if_addr : Uint16.t;
}

let show t =
  let open Bool in
  Printf.sprintf "ie:(vblank:%d, lcd_stat:%d, timer:%d, serial_port:%d, joypad:%d), if:(vblank:%d, lcd_stat:%d, timer:%d, serial_port:%d, joypad:%d)"
    (to_int t.vblank.enabled) (to_int t.lcd_stat.enabled) (to_int t.timer.enabled) (to_int t.serial_port.enabled) (to_int t.joypad.enabled)
    (to_int t.vblank.requested) (to_int t.lcd_stat.requested) (to_int t.timer.requested) (to_int t.serial_port.requested) (to_int t.joypad.requested)

let pp fmt t = Format.fprintf fmt "%s" (show t)

type type_ =
  | VBlank
  | LCD_stat
  | Timer
  | Serial_port
  | Joypad
[@@deriving show]

let create ~ie_addr ~if_addr = {
  vblank = {enabled = true; requested = false};
  lcd_stat = {enabled = true; requested = false};
  timer = {enabled = true; requested = false};
  serial_port = {enabled = true; requested = false};
  joypad = {enabled = true; requested = false};
  ie_addr;
  if_addr;
}

let state_of_type_ t = function
  | VBlank -> t.vblank
  | LCD_stat -> t.lcd_stat
  | Timer -> t.timer
  | Serial_port -> t.serial_port
  | Joypad -> t.joypad

let request t type_ =
  let state = state_of_type_ t type_ in
  state.requested <- true

let clear t type_ =
  let state = state_of_type_ t type_ in
  state.requested <- false

let next t =
  if t.vblank.enabled && t.vblank.requested then Some VBlank
  else if t.lcd_stat.enabled && t.lcd_stat.requested then Some LCD_stat
  else if t.timer.enabled && t.timer.requested then Some Timer
  else if t.serial_port.enabled && t.serial_port.requested then Some Timer
  else if t.joypad.enabled && t.joypad.requested then Some Joypad
  else None

let accepts t ~addr = Uint16.(t.ie_addr = addr || t.if_addr = addr)

let byte_of_bools (b0, b1, b2, b3, b4) : uint8 =
  (if b0 then 0b00001 else 0)
  lor (if b1 then 0b00010 else 0)
  lor (if b2 then 0b00100 else 0)
  lor (if b3 then 0b01000 else 0)
  lor (if b4 then 0b10000 else 0)
  |> Uint8.of_int

let read_byte t addr =
  let open Uint16 in
  if addr = t.ie_addr then
    byte_of_bools
      (t.vblank.enabled, t.lcd_stat.enabled, t.timer.enabled, t.serial_port.enabled, t.joypad.enabled)
  else if addr = t.if_addr then
    byte_of_bools
      (t.vblank.requested, t.lcd_stat.requested, t.timer.enabled, t.serial_port.requested, t.joypad.requested)
  else
    assert false

let bools_of_byte (n : uint8) : bool * bool * bool * bool * bool =
  let open Uint8 in
  (
    n land of_int 0b10000 <> of_int 0,
    n land of_int 0b01000 <> of_int 0,
    n land of_int 0b00100 <> of_int 0,
    n land of_int 0b00010 <> of_int 0,
    n land of_int 0b00001 <> of_int 0
  )

let write_byte t ~addr ~data =
  let open Uint16 in
  let (b4, b3, b2, b1, b0) = bools_of_byte data in
  if addr = t.ie_addr then begin
    t.vblank.enabled <- b0;
    t.lcd_stat.enabled <- b1;
    t.timer.enabled <- b2;
    t.serial_port.enabled <- b3;
    t.joypad.enabled <- b4
  end
  else if addr = t.if_addr then begin
    t.vblank.requested <- b0;
    t.lcd_stat.requested <- b1;
    t.timer.requested <- b2;
    t.serial_port.requested <- b3;
    t.joypad.requested <- b4;
  end else
    assert false
