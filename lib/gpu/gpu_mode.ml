type t =
  | OAM_search      (* Search OAM for sprites that should be rendered on the current scanline *)
  | Pixel_transfer  (* Transfer pixes to LCD *)
  | HBlank          (* Horizontal blank *)
  | VBlank          (* Vertical blank *)
