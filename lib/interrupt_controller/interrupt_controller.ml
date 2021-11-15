open Uints

type t = {
  mutable ie: state;
  mutable if_ : state;
}

and state = {
  addr : uint16;
  vblank : bool;
  lcd_stat : bool;
  timer : bool;
  serial_port : bool;
  joypad : bool;
}

type type_ =
  | VBlank
  | LCD_stat
  | Timer
  | Serial_port
  | Joypad

let show_type_ = function
  | VBlank      -> "VBlank"
  | LCD_stat    -> "LCD_stat"
  | Timer       -> "Timer"
  | Serial_port -> "Serial_port"
  | Joypad      -> "Joypad"

let show t =
  let open Bool in
  Printf.sprintf
    "ie:(vblank:%d, lcd_stat:%d, timer:%d, serial_port:%d, joypad:%d), \
     if:(vblank:%d, lcd_stat:%d, timer:%d, serial_port:%d, joypad:%d)"
    (to_int t.ie.vblank) (to_int t.ie.lcd_stat)
    (to_int t.ie.timer) (to_int t.ie.serial_port) (to_int t.ie.joypad)
    (to_int t.if_.vblank) (to_int t.if_.lcd_stat)
    (to_int t.if_.timer) (to_int t.if_.serial_port) (to_int t.if_.joypad)

let create ~ie_addr ~if_addr = {
  ie  = {addr = ie_addr; vblank = false; lcd_stat = false; timer = false; serial_port = false; joypad = false};
  if_ = {addr = if_addr; vblank = false; lcd_stat = false; timer = false; serial_port = false; joypad = false};
}

let update state type_ b =
  match type_ with
  | VBlank      -> {state with vblank = b}
  | LCD_stat    -> {state with lcd_stat = b}
  | Timer       -> {state with timer = b}
  | Serial_port -> {state with serial_port = b}
  | Joypad      -> {state with joypad = b}


let request t type_ = t.if_ <- update t.if_ type_ true

let clear t type_ = t.if_ <- update t.if_ type_ false

let clear_all t =
  [VBlank; LCD_stat; Timer; Serial_port; Joypad]
  |> List.iter (fun type_ -> clear t type_)

let next t =
  if t.ie.vblank && t.if_.vblank then
    Some VBlank
  else if t.ie.lcd_stat && t.if_.lcd_stat then
    Some LCD_stat
  else if t.ie.timer && t.if_.timer then
    Some Timer
  else if t.ie.serial_port && t.if_.serial_port then
    Some Serial_port
  else if t.ie.joypad && t.if_.joypad then
    Some Joypad
  else
    None

let accepts t addr = Uint16.(t.ie.addr = addr || t.if_.addr = addr)

let byte_of_state s =
  (if s.vblank then 0b00001 else 0)
  lor (if s.lcd_stat    then 0b00010 else 0)
  lor (if s.timer       then 0b00100 else 0)
  lor (if s.serial_port then 0b01000 else 0)
  lor (if s.joypad      then 0b10000 else 0)
  |> Uint8.of_int

let read_byte t addr =
  if Uint16.(addr = t.ie.addr) then
    byte_of_state t.ie
  else if Uint16.(addr = t.if_.addr) then
    (* unused bits always return 1 *)
    Uint8.(of_int 0b11100000 lor byte_of_state t.if_)
  else
    assert false

let state_of_byte b addr =
  let bools_of_byte (n : uint8) : bool * bool * bool * bool * bool =
    let open Uint8 in
    (
      n land of_int 0b10000 <> of_int 0,
      n land of_int 0b01000 <> of_int 0,
      n land of_int 0b00100 <> of_int 0,
      n land of_int 0b00010 <> of_int 0,
      n land of_int 0b00001 <> of_int 0
    )
  in
  let (b4, b3, b2, b1, b0) = bools_of_byte b in
  {
    addr;
    vblank = b0;
    lcd_stat = b1;
    timer = b2;
    serial_port = b3;
    joypad = b4;
  }

let write_byte t ~addr ~data =
  if addr = t.ie.addr then begin
    t.ie <- state_of_byte data t.ie.addr
  end
  else if addr = t.if_.addr then begin
    t.if_ <- state_of_byte data t.if_.addr
  end else
    assert false
