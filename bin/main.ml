open Camlboy_lib
open StdLabels
open Tsdl

let gb_w = 160
let gb_h = 144
let scale = 2

let or_exit = function
  | Error (`Msg e) -> Sdl.log "%s" e; exit 1
  | Ok x -> x

let create_renderer () =
  Sdl.init Sdl.Init.(video + events) |> or_exit;
  let window =
    Sdl.create_window ~w:(gb_w * scale) ~h:(gb_h * scale) "CAMLBOY" Sdl.Window.windowed
    |> or_exit
  in
  Sdl.create_renderer window ~index:(-1) |> or_exit

let create_texture renderer =
  Sdl.create_texture
    renderer
    Sdl.Pixel.format_rgb888
    Sdl.Texture.access_streaming
    ~w:gb_w ~h:gb_h
  |> or_exit

let render_framebuffer ~texture ~renderer ~fb =
  let copy_framebuffer_to_pixels pixels fb =
    for y = 0 to gb_h - 1 do
      for x = 0 to gb_w - 1 do
        let index = (y * gb_w) + x in
        match fb.(y).(x) with
        | `White      -> pixels.{index} <- 0xFFFFFFl
        | `Black      -> pixels.{index} <- 0x000000l
        | `Light_gray -> pixels.{index} <- 0xAAAAAAl
        | `Dark_gray  -> pixels.{index} <- 0x777777l
      done
    done
  in
  let pixels, _ = Sdl.lock_texture texture None Bigarray.int32 |> or_exit in
  copy_framebuffer_to_pixels pixels fb;
  Sdl.unlock_texture texture;
  Sdl.render_copy renderer texture |> or_exit;
  Sdl.render_present renderer

let () =
  Printexc.record_backtrace true;
  let rom_bytes = Read_rom_file.f "./resource/private/tobu.gb" in
  (* let rom_bytes = Read_rom_file.f "./resource/test_roms/blargg/cpu_instrs/cpu_instrs.gb" in *)
  let cartridge =
    Cartridge_header.create ~rom_bytes
    |> Cartridge_header.get_cartridge_type
    |> Cartridge_of_cartridge_type.f
  in
  let module Camlboy = Camlboy.Make (val cartridge) in
  let camlboy = Camlboy.create_with_rom ~rom_bytes ~print_serial_port:false in
  let handle_event () =
    let event = Sdl.Event.create () in
    if Sdl.poll_event (Some event) then begin
      match Sdl.Event.(get event typ |> enum) with
      | `Key_down ->
        let scancode = Sdl.Event.(get event keyboard_scancode) in
        begin match Sdl.Scancode.enum scancode with
          | `Return -> Camlboy.press camlboy Start
          | `Tab    -> Camlboy.press camlboy Select
          | `Z      -> Camlboy.press camlboy B
          | `X      -> Camlboy.press camlboy A
          | `Up     -> Camlboy.press camlboy Up
          | `Down   -> Camlboy.press camlboy Down
          | `Left   -> Camlboy.press camlboy Left
          | `Right  -> Camlboy.press camlboy Right
          | `Escape -> exit 0
          | _       -> ()
        end
      | `Key_up ->
        let scancode = Sdl.Event.(get event keyboard_scancode) in
        begin match Sdl.Scancode.enum scancode with
          | `Return -> Camlboy.release camlboy Start
          | `Tab    -> Camlboy.release camlboy Select
          | `Z      -> Camlboy.release camlboy B
          | `X      -> Camlboy.release camlboy A
          | `Up     -> Camlboy.release camlboy Up
          | `Down   -> Camlboy.release camlboy Down
          | `Left   -> Camlboy.release camlboy Left
          | `Right  -> Camlboy.release camlboy Right
          | _       -> ()
        end
      | `Quit -> exit 0
      | _     -> ()
    end
  in
  let renderer = create_renderer () in
  let texture = create_texture renderer in
  while true do
    (* Printf.printf "%s" (Camlboy.show camlboy);
     * Printf.printf " LY:$%02x" (Camlboy.For_tests.get_ly camlboy);
     * Printf.printf " LCD_STAT:%s" (Camlboy.For_tests.get_lcd_stat camlboy |> Uints.Uint8.show);
     * Printf.printf " MC:%3d" (Camlboy.For_tests.get_mcycles_in_mode camlboy); *)
    begin match Camlboy.run_instruction camlboy with
      | In_frame ->
        ()
      | Frame_ended framebuffer ->
        handle_event ();
        render_framebuffer ~texture ~renderer ~fb:framebuffer;
    end;
    (* Printf.printf " | %s\n" (Camlboy.For_tests.prev_inst camlboy |> Instruction.show); *)
  done
