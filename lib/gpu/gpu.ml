open Uints

type t = {
  td : Tile_data.t;
  tm : Tile_map.t;
  oam : Ram.t;
  bgp : Pallete.t; (* BG palette data *)
  ls : Lcd_stat.t;
  lc : Lcd_control.t;
  lp : Lcd_position.t;
  ic : Interrupt_controller.t;
  mutable mcycles_in_mode : int; (* number of mycycles consumed in current mode *)
}

let create ~tile_data ~tile_map ~oam ~bgp ~lcd_stat ~lcd_control ~lcd_position ~ic = {
  td = tile_data;
  tm = tile_map;
  oam;
  bgp;
  ls = lcd_stat;
  lc = lcd_control;
  lp = lcd_position;
  mcycles_in_mode = 0;
  ic;
}

let oam_read_mcycles = 20
let draw_mcycles = 43
let hblank_mcycles = 51
let one_line_mcycle = oam_read_mcycles + draw_mcycles + hblank_mcycles
let vblank_mcycles = 1140

let check_lyc_eq_ly t =
  if Lcd_stat.is_enabled t.ls LYC_eq_LY &&
     Lcd_position.get_ly t.lp = Lcd_position.get_lyc t.lp then
    Interrupt_controller.request t.ic LCD_stat

let transition_to mode t =
  t.mcycles_in_mode <- 0;
  Lcd_stat.set_gpu_mode t.ls mode

let run t ~mcycles =
  if not (Lcd_control.get_lcd_enable t.lc) then
    ()
  else begin
    check_lyc_eq_ly t;
    t.mcycles_in_mode <- t.mcycles_in_mode + mcycles;
    match Lcd_stat.get_gpu_mode t.ls with
    | OAM_search ->
      if t.mcycles_in_mode >= oam_read_mcycles then
        transition_to Pixel_transfer t
    | Pixel_transfer ->
      if t.mcycles_in_mode >= draw_mcycles then begin
        transition_to HBlank t;
        if Lcd_stat.is_enabled t.ls HBlank then
          Interrupt_controller.request t.ic LCD_stat;
        (* TODO: render_scanline (); *)
      end
    | HBlank ->
      if t.mcycles_in_mode >= hblank_mcycles then begin
        Lcd_position.incr_ly t.lp;
        if Lcd_position.get_ly t.lp = 143 then begin
          transition_to VBlank t;
          if Lcd_stat.is_enabled t.ls VBlank then
            Interrupt_controller.request t.ic LCD_stat;
          Interrupt_controller.request t.ic VBlank;
          (* TODO: copy image data to screen buffer (); *)
        end else
          transition_to OAM_search t
      end
    | VBlank ->
      if t.mcycles_in_mode mod one_line_mcycle = 0 then begin
        Lcd_position.incr_ly t.lp;
        if t.mcycles_in_mode >= vblank_mcycles then begin
          Lcd_position.reset_ly t.lp;
          transition_to OAM_search t;
          if Lcd_stat.is_enabled t.ls OAM then
            Interrupt_controller.request t.ic LCD_stat;
        end
      end
  end
let accepts t addr =
  Tile_map.accepts t.tm addr || Tile_data.accepts t.td addr || Ram.accepts t.oam addr

let read_byte t addr =
  match addr with
  | _ when Tile_data.accepts t.td addr    -> (
      (* VRAM is not accessable during pixel transfer *)
      match Lcd_stat.get_gpu_mode t.ls with
      | Pixel_transfer -> Uint8.of_int 0xFF
      | OAM_search | HBlank | VBlank -> Tile_data.read_byte t.td addr
    )
  | _ when Tile_map.accepts t.tm addr     -> (
      (* VRAM is not accessable during pixel transfer *)
      match Lcd_stat.get_gpu_mode t.ls with
      | Pixel_transfer -> Uint8.of_int 0xFF
      | OAM_search | HBlank | VBlank -> Tile_map.read_byte t.tm addr
    )
  | _ when Ram.accepts t.oam  addr        -> (
      (* VRAM is not accessable during pixel transfer and OAM search *)
      match Lcd_stat.get_gpu_mode t.ls with
      | Pixel_transfer | OAM_search -> Uint8.of_int 0xFF
      | HBlank | VBlank -> Ram.read_byte t.oam addr
    )
  | _ when Pallete.accepts t.bgp addr     -> Pallete.read_byte t.bgp addr
  | _ when Lcd_stat.accepts t.ls addr     -> Lcd_stat.read_byte t.ls addr
  | _ when Lcd_control.accepts t.lc addr  -> Lcd_control.read_byte t.lc addr
  | _ when Lcd_position.accepts t.lp addr -> Lcd_position.read_byte t.lp addr
  | _ -> raise @@ Invalid_argument (Printf.sprintf "Address out of range: %s" (Uint16.show addr))

let write_byte t ~addr ~data =
  match addr with
  | _ when Tile_data.accepts t.td addr -> (
      (* VRAM is not accessable during pixel transfer *)
      match Lcd_stat.get_gpu_mode t.ls with
      | Pixel_transfer -> ()
      | OAM_search | HBlank | VBlank -> Tile_data.write_byte t.td ~addr ~data
    )
  | _ when Tile_map.accepts t.tm addr  -> (
      (* VRAM is not accessable during pixel transfer *)
      match Lcd_stat.get_gpu_mode t.ls with
      | Pixel_transfer -> ()
      | OAM_search | HBlank | VBlank -> Tile_map.write_byte t.tm ~addr ~data
    )
  | _ when Ram.accepts t.oam  addr     -> (
      (* VRAM is not accessable during pixel transfer and OAM search *)
      match Lcd_stat.get_gpu_mode t.ls with
      | Pixel_transfer | OAM_search -> ()
      | HBlank | VBlank -> Ram.write_byte t.oam  ~addr ~data
    )
  | _ when Pallete.accepts t.bgp addr  -> Pallete.write_byte t.bgp ~addr ~data
  | _ when Lcd_stat.accepts t.ls addr     -> Lcd_stat.write_byte t.ls ~addr ~data
  | _ when Lcd_control.accepts t.lc addr  ->
    (* When LCD is disabled, LY and mcycle count is set to 0 and mode is set to HBlank *)
    begin match Lcd_control.write_byte' t.lc ~addr ~data with
      | `Lcd_disabled ->
        Lcd_position.reset_ly t.lp;
        t.mcycles_in_mode <- 0;
        Lcd_stat.set_gpu_mode t.ls HBlank
      | `Nothing -> ()
    end
  | _ when Lcd_position.accepts t.lp addr -> Lcd_position.write_byte t.lp ~addr ~data
  | _ -> raise @@ Invalid_argument (Printf.sprintf "Address out of range: %s" (Uint16.show addr))
