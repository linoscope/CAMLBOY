open Uints

type t

type mode =
  | OAM_search      (* Search OAM for sprites that should be rendered on the current scanline *)
  | Pixel_transfer  (* Transfer pixes to LCD *)
  | HBlank          (* Horizontal blank *)
  | VBlank          (* Vertical blank *)

val create :
  vram:Ram.t
  -> oam:Ram.t
  -> bgp:Mmap_register.t
  -> ly_addr:uint16
  -> ic:Interrupt_controller.t
  -> t

include Runnable_intf.S with type t := t

include Addressable_intf.S with type t := t
