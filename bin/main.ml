open Camlboy_lib
open StdLabels
open Tsdl

let or_exit = function
  | Error (`Msg e) -> Sdl.log "%s" e; exit 1
  | Ok x -> x

let create_renderer () =
  Sdl.init Sdl.Init.video |> or_exit;
  let w = Sdl.create_window ~w:320 ~h:288 "CAMLBOY" Sdl.Window.opengl |> or_exit in
  let renderer = Sdl.create_renderer w ~index:(-1) |> or_exit in
  Sdl.set_render_draw_color renderer 0xFF 0xFF 0xFF 0xFF |> or_exit;
  renderer

let render_frame renderer framebuffer =
  (* TODO: Improve speed by using Sdl_texture *)
  framebuffer |> Array.iteri ~f:(fun y row ->
      row |> Array.iteri ~f:(fun x color ->
          begin match color with
            | `White      -> Sdl.set_render_draw_color renderer 195 217 180 255 |> or_exit
            | `Light_gray -> Sdl.set_render_draw_color renderer 103 167  86 255 |> or_exit
            | `Dark_gray  -> Sdl.set_render_draw_color renderer  42  83  68 255 |> or_exit
            | `Black      -> Sdl.set_render_draw_color renderer   0  40   0 255 |> or_exit
          end;
          let rect = Sdl.Rect.create ~x:(2 * x) ~y:(2 * y) ~w:2 ~h:2 in
          Sdl.render_fill_rect renderer (Some rect) |> or_exit));
  Sdl.render_present renderer


let () =
  let rom_bytes = Read_rom_file.f "./resource/private/mario-land-2.gb" in
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
          | `Tab -> Camlboy.press camlboy Select
          | `Z -> Camlboy.press camlboy B
          | `X -> Camlboy.press camlboy A
          | `Up -> Camlboy.press camlboy Up
          | `Down -> Camlboy.press camlboy Down
          | `Left -> Camlboy.press camlboy Left
          | `Right -> Camlboy.press camlboy Right
          | `Escape -> exit 0
          | _ -> ()
        end
      | `Key_up ->
        let scancode = Sdl.Event.(get event keyboard_scancode) in
        begin match Sdl.Scancode.enum scancode with
          | `Return -> Camlboy.release camlboy Start
          | `Tab -> Camlboy.release camlboy Select
          | `Z -> Camlboy.release camlboy B
          | `X -> Camlboy.release camlboy A
          | `Up -> Camlboy.release camlboy Up
          | `Down -> Camlboy.release camlboy Down
          | `Left -> Camlboy.release camlboy Left
          | `Right -> Camlboy.release camlboy Right
          | _ -> ()
        end
      | `Quit -> exit 0
      | _     -> ()
    end
  in
  let renderer = create_renderer () in
  let cnt = ref 0 in
  while true do
    (* Printf.printf "%s" (Camlboy.show camlboy);
     * Printf.printf " LY:$%02x" (Camlboy.For_tests.get_ly camlboy);
     * Printf.printf " LCD_STAT:%s" (Camlboy.For_tests.get_lcd_stat camlboy |> Uints.Uint8.show);
     * Printf.printf " MC:%3d" (Camlboy.For_tests.get_mcycles_in_mode camlboy); *)
    begin match Camlboy.run_instruction camlboy with
      | In_frame -> ()
      | Frame_ended framebuffer ->
        handle_event ();
        incr cnt;
        if !cnt mod 4 = 0 then
          render_frame renderer framebuffer;
    end;
    (* Printf.printf " | %s\n" (Camlboy.For_tests.prev_inst camlboy |> Instruction.show); *)
  done
