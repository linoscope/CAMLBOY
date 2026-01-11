open Camlboy_lib
open StdLabels
open Tsdl

let gb_w = 160
let gb_h = 144
let scale = 2.
let scaled_gb_w = Float.(of_int gb_w *. scale |> to_int)
let scaled_gb_h = Float.(of_int gb_h *. scale |> to_int)
let sec_per_frame = 1. /. 60.

(* Performance stats tracker - FPS and CPU usage *)
type perf_stats = {
  mutable frame_count : int;
  mutable start_time : float;
  mutable work_time : float;    (* Accumulated work time *)
}

let create_perf_stats () =
  { frame_count = 0; start_time = Unix.gettimeofday (); work_time = 0.0 }

let add_work_time stats dt =
  stats.work_time <- stats.work_time +. dt

let update_perf_stats stats ~on_tick =
  stats.frame_count <- stats.frame_count + 1;
  if stats.frame_count = 60 then begin
    let now = Unix.gettimeofday () in
    let elapsed = now -. stats.start_time in
    let fps = 60. /. elapsed in
    let cpu_pct = if elapsed > 0.0 then 100.0 *. stats.work_time /. elapsed else 0.0 in
    on_tick ~fps ~cpu_pct;
    stats.start_time <- now;
    stats.frame_count <- 0;
    stats.work_time <- 0.0
  end

let or_exit = function
  | Error (`Msg e) -> Sdl.log "%s" e; exit 1
  | Ok x -> x

(* Global reference to prevent GC from collecting the audio callback.
   SDL calls this from its audio thread, so it must stay alive. *)
let audio_callback_ref : Sdl.audio_callback option ref = ref None

let create_renderer () =
  Sdl.init Sdl.Init.(video + events + audio) |> or_exit;
  let window =
    Sdl.create_window ~w:scaled_gb_w ~h:scaled_gb_h "CAMLBOY" Sdl.Window.windowed
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
        | `White      -> pixels.{index} <- 0xE5FBF4l
        | `Light_gray -> pixels.{index} <- 0x97AEB8l
        | `Dark_gray  -> pixels.{index} <- 0x61687Dl
        | `Black      -> pixels.{index} <- 0x221E31l
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

let main_no_throttle
    (type a) (module Camlboy : Camlboy_intf.S with type t = a) (camlboy : a)
    texture renderer =
  let stats = create_perf_stats () in
  while true do
    begin match Camlboy.run_instruction camlboy with
      | In_frame -> ()
      | Frame_ended framebuffer ->
        update_perf_stats stats ~on_tick:(fun ~fps ~cpu_pct:_ ->
          Printf.printf "FPS: %.1f\r%!" fps);
        handle_event (module Camlboy) camlboy;
        render_framebuffer ~texture ~renderer ~fb:framebuffer
    end;
  done

let main_with_trace
    (type a) (module Camlboy : Camlboy_intf.S with type t = a) (camlboy : a)
    texture renderer =
  let buf = Buffer.create 1500 in
  let stats = create_perf_stats () in
  while true do
    let work_start = Unix.gettimeofday () in
    Buffer.add_string buf (Camlboy.show camlboy);
    begin match Camlboy.run_instruction camlboy with
      | In_frame ->
        ()
      | Frame_ended framebuffer ->
        handle_event (module Camlboy) camlboy;
        render_framebuffer ~texture ~renderer ~fb:framebuffer;
        add_work_time stats (Unix.gettimeofday () -. work_start);
        update_perf_stats stats ~on_tick:(fun ~fps ~cpu_pct ->
          Printf.eprintf "FPS: %.1f | CPU: %.0f%%\r%!" fps cpu_pct)
    end;
    Printf.bprintf buf " | %s\n" (Camlboy.For_tests.prev_inst camlboy |> Instruction.show);
    print_string (Buffer.contents buf);
    Buffer.clear buf;
  done

let main_in_60fps
    (type a) (module Camlboy : Camlboy_intf.S with type t = a) (camlboy : a)
    texture renderer =
  let stats = create_perf_stats () in
  let frame_start = ref (Unix.gettimeofday ()) in
  while true do
    begin match Camlboy.run_instruction camlboy with
      | In_frame ->
        ()
      | Frame_ended framebuffer ->
        let work_end = Unix.gettimeofday () in
        add_work_time stats (work_end -. !frame_start);
        handle_event (module Camlboy) camlboy;
        render_framebuffer ~texture ~renderer ~fb:framebuffer;
        update_perf_stats stats ~on_tick:(fun ~fps ~cpu_pct ->
          Printf.printf "FPS: %.1f | CPU: %.0f%%    \r%!" fps cpu_pct);
        let duration = work_end -. !frame_start in
        if duration < sec_per_frame then
          Unix.sleepf (sec_per_frame -. duration);
        frame_start := Unix.gettimeofday ()
    end;
  done

(* Audio-synchronized main loop - tight lock-step synchronization.
   1. Main thread waits for audio callback to signal it needs samples
   2. Audio callback signals need, then waits for samples to be ready
   3. Main thread produces samples, signals back to audio callback
   4. Audio callback copies samples to SDL buffer and returns

   This implementation is due to a limitation with tsdl's implementation
   of OCaml callbacks: when calling the main event loop directly inside
   the audio callback, the program segfaults. *)
let main_audio_sync
    (type a) (module Camlboy : Camlboy_intf.S with type t = a) (camlboy : a)
    texture renderer ~save_audio =
  let apu = Camlboy.get_apu camlboy in
  let audio_sample_rate = Apu.sample_rate apu in
  let wav_writer = Option.map (fun filename ->
    Sdl.log "Saving audio to: %s" filename;
    Wav.create ~filename ~sample_rate:audio_sample_rate ~channels:2
  ) save_audio in
  at_exit (fun () -> Option.iter Wav.close wav_writer);
  let apu = Camlboy.get_apu camlboy in
  (* Use a third of the capacity for SDL buffer to ensure we never overrun and for latency. *)
  let buffer_capacity = Apu.buffer_capacity apu in
  let sdl_buffer_samples = buffer_capacity / 3 in
  (* Synchronization primitives *)
  let mutex = Mutex.create () in
  let cond_need_samples = Condition.create () in
  let cond_samples_ready = Condition.create () in
  let samples_requested = ref 0 in
  let samples_ready = ref false in
  (* Audio callback - signals need, waits for samples, then blits to SDL buffer.
     Called by SDL from audio thread. *)
  let callback (buffer : (int, Bigarray.int16_signed_elt, Bigarray.c_layout) Bigarray.Array1.t) =
    let samples_needed = Bigarray.Array1.dim buffer / 2 in
    Mutex.lock mutex;
    (* Signal main thread we need samples *)
    samples_requested := samples_needed;
    Condition.signal cond_need_samples;
    (* Wait for main thread to produce samples *)
    while not !samples_ready do
      Condition.wait cond_samples_ready mutex
    done;
    samples_ready := false;
    Mutex.unlock mutex;
    ignore (Apu.pop_samples apu ~dst:buffer ~count:samples_needed);
    Option.iter (fun w -> Wav.write_samples w buffer samples_needed) wav_writer
  in
  (* Create and start audio device *)
  let sdl_callback = Sdl.audio_callback Bigarray.int16_signed callback in
  audio_callback_ref := Some sdl_callback;
  let desired_spec = {
    Sdl.as_freq = audio_sample_rate;
    as_format = Sdl.Audio.s16_sys;
    as_channels = 2;
    as_silence = 0;
    as_samples = sdl_buffer_samples;
    as_size = Int32.zero;
    as_callback = Some sdl_callback;
  } in
  begin match Sdl.open_audio_device None false desired_spec Sdl.Audio.allow_frequency_change with
  | Error (`Msg e) ->
    Sdl.log "Failed to open audio device: %s" e;
    exit 1
  | Ok (device_id, obtained_spec) ->
    Sdl.log "Audio: %d Hz, %d channels, %d samples buffer"
      obtained_spec.as_freq obtained_spec.as_channels obtained_spec.as_samples;
    Sdl.pause_audio_device device_id false
  end;
  (* Main loop: wait for request, produce samples, signal ready *)
  let stats = create_perf_stats () in
  (* Stats for frames per audio callback *)
  let frames_this_callback = ref 0 in
  let total_frames = ref 0 in
  let total_callbacks = ref 0 in
  while true do
    (* Wait for audio callback to request samples *)
    Mutex.lock mutex;
    while !samples_requested = 0 do
      Condition.wait cond_need_samples mutex
    done;
    let needed = !samples_requested in
    samples_requested := 0;
    Mutex.unlock mutex;
    (* Run emulation until we have enough samples *)
    let work_start = Unix.gettimeofday () in
    frames_this_callback := 0;
    while Apu.samples_available apu < needed do
      begin match Camlboy.run_instruction camlboy with
        | In_frame -> ()
        | Frame_ended framebuffer ->
          incr frames_this_callback;
          handle_event (module Camlboy) camlboy;
          render_framebuffer ~texture ~renderer ~fb:framebuffer;
          update_perf_stats stats ~on_tick:(fun ~fps ~cpu_pct ->
            let audio_fill = Apu.samples_available apu in
            let fill_pct = 100. *. float_of_int audio_fill /. float_of_int buffer_capacity in
            let avg_frames = if !total_callbacks > 0
              then float_of_int !total_frames /. float_of_int !total_callbacks
              else 0.0 in
            Printf.printf "FPS: %.1f | CPU: %.0f%% | Audio: %d/%d (%.0f%%) | F/cb: %.2f    \r%!"
              fps cpu_pct audio_fill buffer_capacity fill_pct avg_frames)
      end
    done;
    add_work_time stats (Unix.gettimeofday () -. work_start);
    (* Update callback stats *)
    total_frames := !total_frames + !frames_this_callback;
    incr total_callbacks;
    (* Signal audio callback that samples are ready *)
    Mutex.lock mutex;
    samples_ready := true;
    Condition.signal cond_samples_ready;
    Mutex.unlock mutex
  done

(* Audio options - only valid in default mode *)
let no_blep = ref false
let save_audio = ref None

let audio_options = [
  ("--no-blep", Arg.Set no_blep, "Disable band-limited synthesis",
   fun () -> !no_blep);
  ("--save-audio", Arg.String (fun s -> save_audio := Some s), "Save audio to WAV file",
   fun () -> Option.is_some !save_audio);
]

let () =
  let usage_msg =
    "main.exe [--mode {default|60fps|withtrace|no-throttle}] [--no-blep] [--save-audio <file.wav>] <rom_path>"
  in
  let mode = ref "default" in
  let rom_path = ref "./resource/games/tobu.gb" in
  let spec =
    ("--mode", Arg.Set_string mode, "Mode of run") ::
    List.map ~f:(fun (name, action, doc, _) -> (name, action, doc)) audio_options
  in
  Arg.parse spec (fun path -> rom_path := path) usage_msg;
  let rom_bytes = Read_rom_file.f !rom_path in
  let cartridge = Detect_cartridge.f ~rom_bytes in
  let module Camlboy = Camlboy.Make (val cartridge) in
  let use_blep = not !no_blep in
  let camlboy =
    Camlboy.create_with_rom ~use_blep ~rom_bytes ~print_serial_port:false ()
  in
  let renderer = create_renderer () in
  let texture = create_texture renderer in
  let audio_enabled = !mode = "default" in
  let audio_config = if audio_enabled
    then Printf.sprintf "on, blep=%s" (if use_blep then "on" else "off")
    else "off" in
  let used_audio_options =
    List.filter_map ~f:(fun (name, _, _, is_set) ->
      if is_set () then Some name else None
    ) audio_options
  in
  if used_audio_options <> [] && not audio_enabled then begin
    Printf.eprintf "Error: %s require default mode (audio-synced)\n"
      (String.concat ~sep:", " used_audio_options);
    exit 1
  end;
  Sdl.log "Starting CAMLBOY: %s [mode=%s, audio=%s]"
    !rom_path !mode audio_config;
  match !mode with
  | "60fps" -> main_in_60fps (module Camlboy) camlboy texture renderer
  | "withtrace" -> main_with_trace (module Camlboy) camlboy texture renderer
  | "no-throttle" -> main_no_throttle (module Camlboy) camlboy texture renderer
  | _ -> main_audio_sync (module Camlboy) camlboy texture renderer ~save_audio:!save_audio
