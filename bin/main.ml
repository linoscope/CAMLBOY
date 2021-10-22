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
  let copy_framebuffer_to_pixels fb pixels =
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
  Sdl.lock_texture texture None Bigarray.int32 |> or_exit
  |> (fun (pixels, _) -> pixels)
  |> copy_framebuffer_to_pixels fb;
  Sdl.unlock_texture texture;
  Sdl.render_copy renderer texture |> or_exit;
  Sdl.render_present renderer

let () =
  Printexc.record_backtrace true;
  (* let rom_bytes = Read_rom_file.f "./resource/private/mario-land-2.gb" in *)
  (* let rom_bytes = Read_rom_file.f "./resource/test_roms/blargg/instr_timing/instr_timing.gb" in *)
  (* let rom_bytes = Read_rom_file.f "./resource/test_roms/mooneye/tima_reload.gb" in *)
  let rom_bytes = Read_rom_file.f "./resource/test_roms/blargg/cpu_instrs/individual/02-interrupts.gb" in
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
  let buf = Buffer.create 1500 in
  while true do
    Buffer.add_string buf (Camlboy.show camlboy);
    Printf.bprintf buf " tima:%s" (Camlboy.For_tests.get_tima_count camlboy |> Uints.Uint8.show);
    (* Printf.sprintf " LY:$%02x" (Camlboy.For_tests.get_ly camlboy) |> Buffer.add_string buf;
     * Printf.sprintf " LCD_STAT:%s" (Camlboy.For_tests.get_lcd_stat camlboy |> Uints.Uint8.show)
     * |> Buffer.add_string buf;
     * Printf.sprintf " MC:%3d" (Camlboy.For_tests.get_mcycles_in_mode camlboy) |> Buffer.add_string buf; *)
    begin match Camlboy.run_instruction camlboy with
      | In_frame ->
        ()
      | Frame_ended framebuffer ->
        handle_event ();
        render_framebuffer ~texture ~renderer ~fb:framebuffer;
    end;
    Printf.bprintf buf " | %s\n" (Camlboy.For_tests.prev_inst camlboy |> Instruction.show);
    print_string (Buffer.contents buf);
    Buffer.clear buf;
  done

(*  A:$01 F:--HC BC:$0000 DE:$C7BA HL:$DFFC SP:$DFF9 PC:$C00F | RET
 *  A:$01 F:--HC BC:$0000 DE:$C7BA HL:$DFFC SP:$DFFB PC:$C34D | POP AF
 *  A:$00 F:Z-H- BC:$0000 DE:$C7BA HL:$DFFC SP:$DFFD PC:$C34E | LD A, ($FF00+$0F)
 * -A:$E5 F:Z-H- BC:$0000 DE:$C7BA HL:$DFFC SP:$DFFD PC:$C350 | AND A, $04
 * -A:$04 F:--H- BC:$0000 DE:$C7BA HL:$DFFC SP:$DFFD PC:$C352 | JP Z, $C1B9
 * -A:$04 F:--H- BC:$0000 DE:$C7BA HL:$DFFC SP:$DFFD PC:$C355 | POP AF
 * -A:$C2 F:-NH- BC:$0000 DE:$C7BA HL:$DFFC SP:$DFFF PC:$C356 | PUSH HL
 * -A:$C2 F:-NH- BC:$0000 DE:$C7BA HL:$DFFC SP:$DFFD PC:$C357 | CALL $C16B
 * -A:$C2 F:-NH- BC:$0000 DE:$C7BA HL:$DFFC SP:$DFFB PC:$C16B | POP HL
 * -A:$C2 F:-NH- BC:$0000 DE:$C7BA HL:$C35A SP:$DFFD PC:$C16C | PUSH HL
 * -A:$C2 F:-NH- BC:$0000 DE:$C7BA HL:$C35A SP:$DFFB PC:$C16D | PUSH AF
 * -A:$C2 F:-NH- BC:$0000 DE:$C7BA HL:$C35A SP:$DFF9 PC:$C16E | INC HL
 * -A:$C2 F:-NH- BC:$0000 DE:$C7BA HL:$C35B SP:$DFF9 PC:$C16F | INC HL
 * -A:$C2 F:-NH- BC:$0000 DE:$C7BA HL:$C35C SP:$DFF9 PC:$C170 | LD A, (HL+)
 * -A:$05 F:-NH- BC:$0000 DE:$C7BA HL:$C35D SP:$DFF9 PC:$C171 | LD ($D804), A
 * -A:$05 F:-NH- BC:$0000 DE:$C7BA HL:$C35D SP:$DFF9 PC:$C174 | LD A, L
 * -A:$5D F:-NH- BC:$0000 DE:$C7BA HL:$C35D SP:$DFF9 PC:$C175 | LD ($D805), A
 * +A:$E1 F:Z-H- BC:$0000 DE:$C7BA HL:$DFFC SP:$DFFD PC:$C350 | AND A, $04
 * +A:$00 F:Z-H- BC:$0000 DE:$C7BA HL:$DFFC SP:$DFFD PC:$C352 | JP Z, $C1B9
 * +A:$00 F:Z-H- BC:$0000 DE:$C7BA HL:$DFFC SP:$DFFD PC:$C1B9 | LD A, ($D805)
 * +A:$03 F:Z-H- BC:$0000 DE:$C7BA HL:$DFFC SP:$DFFD PC:$C1BC | LD L, A
 * +A:$03 F:Z-H- BC:$0000 DE:$C7BA HL:$DF03 SP:$DFFD PC:$C1BD | LD A, ($D806)
 * +A:$C3 F:Z-H- BC:$0000 DE:$C7BA HL:$DF03 SP:$DFFD PC:$C1C0 | LD H, A
 * +A:$C3 F:Z-H- BC:$0000 DE:$C7BA HL:$C303 SP:$DFFD PC:$C1C1 | LD A, (HL)
 * +A:$54 F:Z-H- BC:$0000 DE:$C7BA HL:$C303 SP:$DFFD PC:$C1C2 | OR A, A
 * +A:$54 F:---- BC:$0000 DE:$C7BA HL:$C303 SP:$DFFD PC:$C1C3 | JR Z, 9
 * +A:$54 F:---- BC:$0000 DE:$C7BA HL:$C303 SP:$DFFD PC:$C1C5 | CALL $C0BA
 * +A:$54 F:---- BC:$0000 DE:$C7BA HL:$C303 SP:$DFFB PC:$C0BA | PUSH AF
 * +A:$54 F:---- BC:$0000 DE:$C7BA HL:$C303 SP:$DFF9 PC:$C0BB | LD A, $0A
 * +A:$0A F:---- BC:$0000 DE:$C7BA HL:$C303 SP:$DFF9 PC:$C0BD | CALL $D801
 * +A:$0A F:---- BC:$0000 DE:$C7BA HL:$C303 SP:$DFF7 PC:$D801 | JP $C7D3
 * +A:$0A F:---- BC:$0000 DE:$C7BA HL:$C303 SP:$DFF7 PC:$C7D3 | PUSH AF
 * +A:$0A F:---- BC:$0000 DE:$C7BA HL:$C303 SP:$DFF5 PC:$C7D4 | LD ($FF00+$01), A
 * +A:$0A F:---- BC:$0000 DE:$C7BA HL:$C303 SP:$DFF5 PC:$C7D6 | LD A, $81
 * +A:$81 F:---- BC:$0000 DE:$C7BA HL:$C303 SP:$DFF5 PC:$C7D8 | LD ($FF00+$02), A
 * +A:$81 F:---- BC:$0000 DE:$C7BA HL:$C303 SP:$DFF5 PC:$C7DA | PUSH AF
 * +A:$81 F:---- BC:$0000 DE:$C7BA HL:$C303 SP:$DFF3 PC:$C7DB | LD A, $08
 * +A:$08 F:---- BC:$0000 DE:$C7BA HL:$C303 SP:$DFF3 PC:$C7DD | CALL $C012
 * +A:$08 F:---- BC:$0000 DE:$C7BA HL:$C303 SP:$DFF1 PC:$C012 | PUSH AF
 * +A:$08 F:---- BC:$0000 DE:$C7BA HL:$C303 SP:$DFEF PC:$C013 | LD A, $DF
 * +A:$DF F:---- BC:$0000 DE:$C7BA HL:$C303 SP:$DFEF PC:$C015 | CALL $C003
 * +A:$DF F:---- BC:$0000 DE:$C7BA HL:$C303 SP:$DFED PC:$C003 | SUB A, $05 *)
