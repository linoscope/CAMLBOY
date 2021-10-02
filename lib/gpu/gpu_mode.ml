type t =
  | OAM_search     (* Mode 2. Search OAM for sprites that should be rendered on current scanline *)
  | Pixel_transfer (* Mode 3. Transfer pixes to LCD *)
  | HBlank         (* Mode 0. Horizontal blank *)
  | VBlank         (* Mode 1. Vertical blank *)

let to_int = function
  | OAM_search -> 2
  | Pixel_transfer -> 3
  | HBlank -> 0
  | VBlank -> 1
