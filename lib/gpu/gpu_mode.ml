type t =
  | OAM_search     (* Mode 2. Search OAM for sprites that should be rendered on current scanline *)
  | Pixel_transfer (* Mode 3. Transfer pixes to LCD *)
  | HBlank         (* Mode 0. Horizontal blank *)
  | VBlank         (* Mode 1. Vertical blank *)
