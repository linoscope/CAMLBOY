open Uints

type state =
  | Enabled
  | Disabled
  | HBlank_after_enabled

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
  mutable state : state;
  frame_buffer : [`White | `Light_gray | `Dark_gray | `Black ] array array; (* frame_buffer.(y).(x) :=  color of yth row and xth column*)
}

(* check if LY=LYC and set lcd_stat and request interrupt accordingly*)
let handle_ly_eq_lyc t =
  let ly = Lcd_position.get_ly t.lp in
  let lyc = Lcd_position.get_lyc t.lp in
  let ly_eq_lyc = ly = lyc in
  Lcd_stat.set_lyc_eq_ly_flag t.ls ly_eq_lyc;
  if ly_eq_lyc && Lcd_stat.is_enabled t.ls LYC_eq_LY then
    Interrupt_controller.request t.ic LCD_stat

let create
    ~tile_data
    ~tile_map
    ~oam
    ~bgp
    ~lcd_stat
    ~lcd_control
    ~lcd_position
    ~ic
  =
  let t = {
    td = tile_data;
    tm = tile_map;
    oam;
    bgp;
    ls = lcd_stat;
    lc = lcd_control;
    lp = lcd_position;
    mcycles_in_mode = 0;
    state = Enabled;
    ic;
    frame_buffer = Array.make_matrix 144 160 `White; }
  in
  handle_ly_eq_lyc t;
  t

let set_mcycles_in_mode t mcycles_in_mode = t.mcycles_in_mode <- mcycles_in_mode

let get_frame_buffer t = t.frame_buffer

let render_bg_line t =
  let scy = Lcd_position.get_scy t.lp in
  let scx = Lcd_position.get_scx t.lp in
  let tile_data_area = Lcd_control.get_tile_data_area t.lc in
  let tile_map_area  = Lcd_control.get_bg_tile_map_area t.lc in
  let ly = Lcd_position.get_ly t.lp in
  let y = (scy + ly) mod 255 in
  let row_in_tile = y mod 8 in
  for lx = 0 to 159 do
    let x = (scx + lx) mod 255 in
    let col_in_tile = x mod 8 in
    let tile_id = Tile_map.get_tile_id t.tm ~area:tile_map_area ~y ~x in
    let pixel_color_id = Tile_data.get_pixel t.td
        ~index:tile_id
        ~area:tile_data_area
        ~row:row_in_tile
        ~col:col_in_tile
    in
    let color = Pallete.lookup t.bgp pixel_color_id in
    t.frame_buffer.(ly).(lx) <- color
  done

let render_line t =
  if Lcd_control.get_bg_window_display t.lc then
    render_bg_line t;
  if Lcd_control.get_obj_enable t.lc then
    ()
(* TODO: render_sprites t; *)

let incr_ly t =
  Lcd_position.incr_ly t.lp;
  Lcd_position.get_ly t.lp

let oam_search_mcycles = 20     (*  80 / 4 *)
let pixel_transfer_mcycles = 43 (* 172 / 4 *)
let hblank_mcycles = 51         (* 204 / 4 *)
let one_line_mcycle = oam_search_mcycles + pixel_transfer_mcycles + hblank_mcycles (* 114 *)

let run t ~mcycles =
  match t.state with
  | Disabled -> ()
  | Enabled ->
    t.mcycles_in_mode <- t.mcycles_in_mode + mcycles;
    begin match Lcd_stat.get_gpu_mode t.ls with
      | OAM_search ->
        if t.mcycles_in_mode >= oam_search_mcycles then begin
          t.mcycles_in_mode <- t.mcycles_in_mode mod oam_search_mcycles;
          Lcd_stat.set_gpu_mode t.ls Pixel_transfer;
        end
      | Pixel_transfer ->
        if t.mcycles_in_mode >= pixel_transfer_mcycles then begin
          t.mcycles_in_mode <- t.mcycles_in_mode mod pixel_transfer_mcycles;
          Lcd_stat.set_gpu_mode t.ls HBlank;
          if Lcd_stat.is_enabled t.ls HBlank then
            Interrupt_controller.request t.ic LCD_stat;
          render_line t;
        end
      | HBlank ->
        if t.mcycles_in_mode >= hblank_mcycles then begin
          t.mcycles_in_mode <- t.mcycles_in_mode mod hblank_mcycles;
          let ly = incr_ly t in
          handle_ly_eq_lyc t;
          if ly = 144 then begin
            Lcd_stat.set_gpu_mode t.ls VBlank;
            if Lcd_stat.is_enabled t.ls VBlank then
              Interrupt_controller.request t.ic LCD_stat;
            Interrupt_controller.request t.ic VBlank;
            (* TODO: copy image data to screen buffer (); *)
          end else begin
            Lcd_stat.set_gpu_mode t.ls OAM_search;
            if Lcd_stat.is_enabled t.ls OAM then
              Interrupt_controller.request t.ic LCD_stat;
          end
        end
      | VBlank ->
        if t.mcycles_in_mode >= one_line_mcycle then begin
          t.mcycles_in_mode <- t.mcycles_in_mode mod one_line_mcycle;
          let ly = incr_ly t in
          handle_ly_eq_lyc t;
          if ly = 154 then begin
            Lcd_position.reset_ly t.lp;
            handle_ly_eq_lyc t;
            Lcd_stat.set_gpu_mode t.ls OAM_search;
            if Lcd_stat.is_enabled t.ls OAM then
              Interrupt_controller.request t.ic LCD_stat;
          end
        end
    end
  | HBlank_after_enabled ->
    (* The HBlank after transitioning from enabled to disabled
     * seems to have two differences from normal HBLank (based on inspecting BGB):
     * 1. The mode only has 33 mcylces remaining (starts with +18 mcycles)
     * 2. LY does not increment when HBLank ends *)
    t.mcycles_in_mode <- t.mcycles_in_mode + mcycles;
    if t.mcycles_in_mode >= hblank_mcycles then begin
      t.mcycles_in_mode <- t.mcycles_in_mode mod hblank_mcycles;
      t.state <- Enabled;
      handle_ly_eq_lyc t;
      Lcd_stat.set_gpu_mode t.ls OAM_search;
      if Lcd_stat.is_enabled t.ls OAM then
        Interrupt_controller.request t.ic LCD_stat;
    end

let accepts t addr =
  Tile_map.accepts t.tm addr
  || Tile_data.accepts t.td addr
  || Ram.accepts t.oam addr
  || Pallete.accepts t.bgp addr
  || Lcd_stat.accepts t.ls addr
  || Lcd_control.accepts t.lc addr
  || Lcd_position.accepts t.lp addr

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
      | OAM_search | HBlank | VBlank ->
        Tile_data.write_byte t.td ~addr ~data;
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
    let lcd_enable_before = Lcd_control.get_lcd_enable t.lc in
    Lcd_control.write_byte t.lc ~addr ~data;
    let lcd_enable_after = Lcd_control.get_lcd_enable t.lc in
    begin match lcd_enable_before, lcd_enable_after with
      | true, false ->
        (* When LCD is disabled, LY and mcycle count is set to 0 and mode is set to HBlank. *)
        Lcd_position.reset_ly t.lp;
        t.mcycles_in_mode <- 0;
        t.state <- Disabled;
        Lcd_stat.set_gpu_mode t.ls HBlank
      | false, true ->
        (* "33" is from observation of what happens when LCD is enabled in BGB *)
        t.state <- HBlank_after_enabled;
        t.mcycles_in_mode <- 18;
        handle_ly_eq_lyc t;
      | true, true
      | false, false -> ()
    end

  | _ when Lcd_position.accepts t.lp addr -> Lcd_position.write_byte t.lp ~addr ~data
  | _ -> raise @@ Invalid_argument (Printf.sprintf "Address out of range: %s" (Uint16.show addr))


let oam_dma_write t ~offset ~data = Ram.write_with_offset t.oam ~offset ~data

module For_tests = struct

  let run t ~mcycles =
    let mode_before = Lcd_stat.get_gpu_mode t.ls in
    run t ~mcycles;
    let mode_after = Lcd_stat.get_gpu_mode t.ls in
    if mode_before != mode_after then
      `Mode_changed
    else
      `Mode_not_changed

  let show t =
    let interrupt_str = match Interrupt_controller.next t.ic with
      | None -> "-"
      | Some int -> Interrupt_controller.show_type_ int
    in
    Printf.sprintf "mode=%d, mcycles=%4d, ly=%3d, lcd_stat=%s, interrupt=%s)"
      (Lcd_stat.get_gpu_mode t.ls |> Gpu_mode.to_int)
      t.mcycles_in_mode
      (Lcd_position.get_ly t.lp)
      (Lcd_stat.peek t.ls |> Uint8.show)
      interrupt_str

  let get_mcycles_in_mode t = t.mcycles_in_mode

end
