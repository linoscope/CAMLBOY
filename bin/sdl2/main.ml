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

let handle_event (type a) (module Camlboy : Camlboy_intf.S with type t = a) (camlboy : a) =
  let event = Sdl.Event.create () in
  if Sdl.poll_event (Some event) then begin
    match Sdl.Event.(get event typ |> enum) with
    | `Key_down ->
      let scancode = Sdl.Event.(get event keyboard_scancode) in
      begin match Sdl.Scancode.enum scancode with
        | `Return -> Camlboy.press camlboy Start
        | `Lshift -> Camlboy.press camlboy Select
        | `J      -> Camlboy.press camlboy B
        | `K      -> Camlboy.press camlboy A
        | `W      -> Camlboy.press camlboy Up
        | `S      -> Camlboy.press camlboy Down
        | `A      -> Camlboy.press camlboy Left
        | `D      -> Camlboy.press camlboy Right
        | `Escape -> exit 0
        | _       -> ()
      end
    | `Key_up ->
      let scancode = Sdl.Event.(get event keyboard_scancode) in
      begin match Sdl.Scancode.enum scancode with
        | `Return -> Camlboy.release camlboy Start
        | `Lshift -> Camlboy.release camlboy Select
        | `J      -> Camlboy.release camlboy B
        | `K      -> Camlboy.release camlboy A
        | `W      -> Camlboy.release camlboy Up
        | `S      -> Camlboy.release camlboy Down
        | `A      -> Camlboy.release camlboy Left
        | `D      -> Camlboy.release camlboy Right
        | _       -> ()
      end
    | `Quit -> exit 0
    | _     -> ()
  end

let main_with_fps
    (type a) (module Camlboy : Camlboy_intf.S with type t = a) (camlboy : a) texture renderer =
  let cnt = ref 0 in
  let start_time = ref (Unix.gettimeofday ()) in
  while true do
    begin match Camlboy.run_instruction camlboy with
      | In_frame ->
        ()
      | Frame_ended framebuffer ->
        incr cnt;
        if !cnt = 60 then begin
          let end_time = Unix.gettimeofday () in
          let sec_per_60_frame = (end_time -. !start_time) in
          let fps = 60. /. sec_per_60_frame in
          start_time := end_time;
          Printf.printf "fps=%f\n" fps; flush_all ();
          cnt := 0;
        end;
        handle_event (module Camlboy) camlboy;
        render_framebuffer ~texture ~renderer ~fb:framebuffer;

    end;
  done

let main_with_trace
    (type a) (module Camlboy : Camlboy_intf.S with type t = a) (camlboy : a) texture renderer =
  let buf = Buffer.create 1500 in
  while true do
    Buffer.add_string buf (Camlboy.show camlboy);
    begin match Camlboy.run_instruction camlboy with
      | In_frame ->
        ()
      | Frame_ended framebuffer ->
        handle_event (module Camlboy) camlboy;
        render_framebuffer ~texture ~renderer ~fb:framebuffer;

    end;
    Printf.bprintf buf " | %s\n" (Camlboy.For_tests.prev_inst camlboy |> Instruction.show);
    print_string (Buffer.contents buf);
    Buffer.clear buf;
  done

let () =
  let usage_msg = "main.exe [--trace] <rom-path>" in
  let show_trace = ref false in
  let rom_path = ref "./resource/games/tobu.gb" in
  let spec = [("--trace", Arg.Set show_trace,  "Print trace")] in
  Arg.parse spec (fun path -> rom_path := path) usage_msg;
  let rom_bytes = Read_rom_file.f !rom_path in
  let cartridge = Detect_cartridge.f ~rom_bytes in
  let module Camlboy = Camlboy.Make (val cartridge) in
  let camlboy = Camlboy.create_with_rom ~rom_bytes ~print_serial_port:false in
  let renderer = create_renderer () in
  let texture = create_texture renderer in
  if !show_trace then
    main_with_trace (module Camlboy) camlboy texture renderer
  else
    main_with_fps (module Camlboy) camlboy texture renderer
