open Uints

type t = {
  addr : uint16;
  mutable lyc_eq_ly_int_enabled : bool;
  mutable oam_int_enabled       : bool;
  mutable vblank_int_enabled    : bool;
  mutable hblank_int_enabled    : bool;
  mutable lyc_eq_ly_flag        : bool;
  mutable gpu_mode              : Gpu_mode.t;
}

type stat_interupt_source =
  | LYC_eq_LY
  | OAM
  | VBlank
  | HBlank

let create ~addr = {
  addr;
  lyc_eq_ly_int_enabled = false;
  oam_int_enabled       = false;
  vblank_int_enabled    = false;
  hblank_int_enabled    = false;
  lyc_eq_ly_flag        = false;
  gpu_mode              = OAM_search;
}

let is_enabled t = function
  | LYC_eq_LY -> t.lyc_eq_ly_int_enabled
  | OAM       -> t.oam_int_enabled
  | VBlank    -> t.vblank_int_enabled
  | HBlank    -> t.hblank_int_enabled

let get_lyc_eq_ly_flag t = t.lyc_eq_ly_flag

let set_lyc_eq_ly_flag t b = t.lyc_eq_ly_flag <- b

let get_gpu_mode t = t.gpu_mode

let set_gpu_mode t mode = t.gpu_mode <- mode


let accepts t addr = Uint16.(addr = t.addr)

let read_byte t addr =
  if accepts t addr then begin
    let (b1, b0) = match t.gpu_mode with
      | HBlank -> (false, false)
      | VBlank -> (false, true)
      | OAM_search -> (true, false)
      | Pixel_transfer -> (true, true)
    in
    Bit_util.byte_of_bitflags
      true (* bit 7 is always true *)
      (is_enabled t LYC_eq_LY)
      (is_enabled t OAM)
      (is_enabled t VBlank)
      (is_enabled t HBlank)
      t.lyc_eq_ly_flag
      b1
      b0
  end else
    raise @@ Invalid_argument "Address out of bounds"

let write_byte t ~addr ~data =
  if accepts t addr then begin
    let (_, b6, b5, b4, b3, _, _, _) = Bit_util.bitflags_of_byte data in
    t.lyc_eq_ly_int_enabled <- b6;
    t.oam_int_enabled <- b5;
    t.vblank_int_enabled <- b4;
    t.hblank_int_enabled <- b3
  end else
    raise @@ Invalid_argument "Address out of bounds"
