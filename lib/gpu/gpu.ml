open Uints

type t = {
  vram : Ram.t;          (* Tile data and tile map for the background*)
  oam : Ram.t;
  bgp : Pallete.t;      (* BG palette data *)
  lcd_stat : Lcd_stat.t;
  lcd_control : Lcd_control.t;
  mutable mcycles_in_mode : int; (* number of mycycles consumed in current mode *)
  ly_addr : uint16;           (* Address to access ly value *)
  mutable ly : int;           (* LCD Y Coordinate *)
  ic : Interrupt_controller.t
}

let create ~vram ~oam ~bgp ~lcd_stat ~lcd_control ~ly_addr ~ic = {
  vram;
  oam;
  bgp;
  lcd_stat;
  lcd_control;
  mcycles_in_mode = 0;
  ly_addr;
  ly = 0;
  ic;
}

let oam_read_mcycles = 20
let draw_mcycles = 43
let hblank_mcycles = 51
let one_line_mcycle = oam_read_mcycles + draw_mcycles + hblank_mcycles
let vblank_mcycles = 1140

let run t ~mcycles =
  t.mcycles_in_mode <- t.mcycles_in_mode + mcycles;
  let transition_to mode t =
    t.mcycles_in_mode <- 0;
    Lcd_stat.set_gpu_mode t.lcd_stat mode
  in
  match Lcd_stat.get_gpu_mode t.lcd_stat with
  | OAM_search ->
    if t.mcycles_in_mode >= oam_read_mcycles then
      transition_to Pixel_transfer t
  | Pixel_transfer ->
    if t.mcycles_in_mode >= draw_mcycles then begin
      transition_to HBlank t;
      (* TODO: render_scanline (); *)
    end
  | HBlank ->
    if t.mcycles_in_mode >= hblank_mcycles then begin
      t.ly <- t.ly + 1;
      if t.ly = 143 then begin
        transition_to VBlank t;
        Interrupt_controller.request t.ic VBlank;
        (* TODO: copy image data to screen buffer (); *)
      end else
        transition_to OAM_search t
    end
  | VBlank ->
    if t.mcycles_in_mode mod one_line_mcycle = 0 then begin
      t.ly <- t.ly + 1;
      if t.mcycles_in_mode >= vblank_mcycles then begin
        t.ly <- 0;
        transition_to OAM_search t
      end
    end

let accepts t addr = Ram.accepts t.vram addr || Ram.accepts t.oam addr || Uint16.(addr = t.ly_addr)

let read_byte t addr =
  match addr with
  | _ when Ram.accepts t.vram addr    -> Ram.read_byte t.vram addr
  | _ when Ram.accepts t.oam  addr    -> Ram.read_byte t.oam addr
  | _ when Pallete.accepts t.bgp addr -> Pallete.read_byte t.bgp addr
  | _ when Uint16.(addr = t.ly_addr)  -> t.ly |> Uint8.of_int
  | _ -> raise @@ Invalid_argument (Printf.sprintf "Address out of range: %s" (Uint16.show addr))

let write_byte t ~addr ~data =
  match addr with
  | _ when Ram.accepts t.vram addr    -> Ram.write_byte t.vram ~addr ~data
  | _ when Ram.accepts t.oam  addr    -> Ram.write_byte t.oam  ~addr ~data
  | _ when Pallete.accepts t.bgp addr -> Pallete.write_byte t.bgp ~addr ~data
  | _ when Uint16.(addr = t.ly_addr)  -> () (* LY is read only *)
  | _ -> raise @@ Invalid_argument (Printf.sprintf "Address out of range: %s" (Uint16.show addr))
