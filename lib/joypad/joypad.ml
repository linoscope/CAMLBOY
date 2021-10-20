open Uints

type key = Down | Up | Left | Right | Start | Select | B | A

type mode = None | Direction | Action

module Key_state = struct
  type t = Pressed | Not_pressed
  let to_bool t = t = Not_pressed (* 0=Pressed, 1=Not_pressed *)
end

type t = {
  addr : uint16;
  mutable mode   : mode;
  mutable down   : Key_state.t;
  mutable up     : Key_state.t;
  mutable left   : Key_state.t;
  mutable right  : Key_state.t;
  mutable start  : Key_state.t;
  mutable select : Key_state.t;
  mutable b      : Key_state.t;
  mutable a      : Key_state.t;
}

let create ~addr = {
  addr;
  mode = Direction;
  down   = Not_pressed;
  up     = Not_pressed;
  left   = Not_pressed;
  right  = Not_pressed;
  start  = Not_pressed;
  select = Not_pressed;
  b      = Not_pressed;
  a      = Not_pressed
}

let press t = function
  | Down   -> t.down   <- Pressed
  | Up     -> t.up     <- Pressed
  | Left   -> t.left   <- Pressed
  | Right  -> t.right  <- Pressed
  | Start  -> t.start  <- Pressed
  | Select -> t.select <- Pressed
  | B      -> t.b      <- Pressed
  | A      -> t.a      <- Pressed

let release t = function
  | Down   -> t.down   <- Not_pressed
  | Up     -> t.up     <- Not_pressed
  | Left   -> t.left   <- Not_pressed
  | Right  -> t.right  <- Not_pressed
  | Start  -> t.start  <- Not_pressed
  | Select -> t.select <- Not_pressed
  | B      -> t.b      <- Not_pressed
  | A      -> t.a      <- Not_pressed



(* Bit 7 - Not used
 * Bit 6 - Not used
 * Bit 5 - P15 Select Action buttons    (0=Select)
 * Bit 4 - P14 Select Direction buttons (0=Select)
 * Bit 3 - P13 Input: Down  or Start    (0=Pressed) (Read Only)
 * Bit 2 - P12 Input: Up    or Select   (0=Pressed) (Read Only)
 * Bit 1 - P11 Input: Left  or B        (0=Pressed) (Read Only)
 * Bit 0 - P10 Input: Right or A        (0=Pressed) (Read Only) *)

let read_byte t _ =
  match t.mode with
  | Direction ->
    Bit_util.byte_of_bitflags
      false
      false
      false
      true
      (t.down  |> Key_state.to_bool)
      (t.up    |> Key_state.to_bool)
      (t.left  |> Key_state.to_bool)
      (t.right |> Key_state.to_bool)
  | Action ->
    Bit_util.byte_of_bitflags
      false
      false
      true
      false
      (t.start  |> Key_state.to_bool)
      (t.select |> Key_state.to_bool)
      (t.b      |> Key_state.to_bool)
      (t.a      |> Key_state.to_bool)
  | None -> Uint8.of_int 0x0F

let write_byte t ~addr:_ ~data =
  let (_, _, b5, b4, _, _, _, _) = Bit_util.bitflags_of_byte data in
  if not b4 then
    t.mode <- Direction
  else if not b5 then
    t.mode <- Action
  else
    t.mode <- None

let accepts t addr = addr = t.addr
