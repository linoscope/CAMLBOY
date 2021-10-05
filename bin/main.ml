open Camlboy_lib
open StdLabels
open Tsdl

let or_exit = function
  | Error (`Msg e) -> Sdl.log "%s" e; exit 1
  | Ok x -> x

let init_graphics () =
  Sdl.init Sdl.Init.video |> or_exit;
  let w = Sdl.create_window ~w:800 ~h:720 "CAMLBOY" Sdl.Window.opengl |> or_exit in
  let renderer = Sdl.create_renderer w ~index:(-1) |> or_exit in
  Sdl.set_render_draw_color renderer 0xFF 0xFF 0xFF 0xFF |> or_exit;
  renderer

let clear_graphics renderer =
  Sdl.set_render_draw_color renderer 0xFF 0xFF 0xFF 0xFF |> or_exit;
  Sdl.render_clear renderer |> or_exit

let render_frame renderer framebuffer =
  framebuffer |> Array.iteri ~f:(fun y row ->
      row |> Array.iteri ~f:(fun x color ->
          begin match color with
            | `White      -> Sdl.set_render_draw_color renderer 0xFF 0xFF 0xFF 0xFF |> or_exit
            | `Light_gray -> Sdl.set_render_draw_color renderer 0x80 0x80 0x80 0xFF |> or_exit
            | `Dark_gray  -> Sdl.set_render_draw_color renderer 0xD8 0xD8 0xD8 0xFF |> or_exit
            | `Black      -> Sdl.set_render_draw_color renderer 0x00 0x00 0x00 0xFF |> or_exit
          end;
          let rect = Sdl.Rect.create ~x:(5 * x) ~y:(5 * y) ~w:5 ~h:5 in
          Sdl.render_fill_rect renderer (Some rect) |> or_exit));
  Sdl.render_present renderer


let handle_event () =
  let event = Sdl.Event.create () in
  if Sdl.poll_event (Some event) then begin
    match Sdl.Event.(get event typ |> enum) with
    | `Key_down ->
      let scancode = Sdl.Event.(get event keyboard_scancode) in
      begin match Sdl.Scancode.enum scancode with
        | `Escape -> exit 0
        | _       -> ()
      end
    | `Quit   -> exit 0
    | _       -> ()
  end

let () =
  let rom_bytes = Read_rom_file.f "./resource/test_roms/blargg/cpu_instrs/individual/01-special.gb" in
  let camlboy = Camlboy.create_with_rom ~rom_bytes ~echo_flag:false in
  let renderer = init_graphics () in
  while true do
    Printf.printf "%s" (Camlboy.show camlboy);
    Printf.printf " LY:%d" (Camlboy.For_tests.get_ly camlboy);
    (* Printf.printf " LCD_STAT:%s" (Camlboy.For_tests.get_lcd_stat camlboy |> Uints.Uint8.show);
     * Printf.printf " MC:%3d" (Camlboy.For_tests.get_mcycles_in_mode camlboy); *)
    begin match Camlboy.run_instruction camlboy with
      | In_frame -> ()
      | Frame_ended framebuffer ->
        render_frame renderer framebuffer;
    end;
    handle_event ();
    Printf.printf " | %s\n" (Camlboy.For_tests.prev_inst camlboy |> Instruction.show);
  done
