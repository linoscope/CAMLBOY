open Camlboy_lib
open Brr
open Brr_canvas
open Brr_io
open Fut.Syntax


let gb_w = 160
let gb_h = 144

type rom_option = { name : string; path : string }

let rom_options = [
  {name = "The Bouncing Ball" ; path = "./the-bouncing-ball.gb"};
  {name = "Tobu Tobu Girl"    ; path = "./tobu.gb"};
  {name = "Cavern"            ; path = "./cavern.gb"};
  {name = "Into The Blue"     ; path = "./into-the-blue.gb"};
  {name = "Rocket Man Demo"   ; path = "./rocket-man-demo.gb"};
  {name = "Retroid"           ; path = "./retroid.gb"};
  {name = "Wishing Sarah"     ; path = "./dreaming-sarah.gb"};
  {name = "SHEEP IT UP"       ; path = "./sheep-it-up.gb"};
]

let find_el_by_id id = Document.find_el_by_id G.document (Jstr.v id) |> Option.get

let draw_framebuffer ctx image_data fb =
  let d = C2d.Image_data.data image_data |> Tarray.to_bigarray1 in
  for y = 0 to gb_h - 1 do
    for x = 0 to gb_w - 1 do
      let off = 4 * (y * gb_w + x) in
      let open Bigarray in
      match fb.(y).(x) with
      | `White ->
        Array1.set d (off    ) 0xE5;
        Array1.set d (off + 1) 0xFB;
        Array1.set d (off + 2) 0xF4;
        Array1.set d (off + 3) 0xFF;
      | `Light_gray ->
        Array1.set d (off    ) 0x97;
        Array1.set d (off + 1) 0xAE;
        Array1.set d (off + 2) 0xB8;
        Array1.set d (off + 3) 0xFF;
      | `Dark_gray ->
        Array1.set d (off    ) 0x61;
        Array1.set d (off + 1) 0x68;
        Array1.set d (off + 2) 0x7D;
        Array1.set d (off + 3) 0xFF;
      | `Black ->
        Array1.set d (off    ) 0x22;
        Array1.set d (off + 1) 0x1E;
        Array1.set d (off + 2) 0x31;
        Array1.set d (off + 3) 0xFF;
    done
  done;
  C2d.put_image_data ctx image_data ~x:0 ~y:0

(** Manages state that need to be reset when loading a new rom *)
module State = struct
  let run_id = ref None
  let key_down_listener = ref None
  let key_up_listener = ref None
  let audio_context : Web_audio.AudioContext.t option ref = ref None
  let script_processor : Web_audio.ScriptProcessorNode.t option ref = ref None

  let set_listener down up =
    key_down_listener := Some down;
    key_up_listener := Some up

  let clear () =
    begin match !run_id with
      | None -> ()
      | Some timer_id ->
        G.stop_timer timer_id;
        G.cancel_animation_frame timer_id;
    end;
    begin match !key_down_listener with
      | None -> ()
      | Some lister -> Ev.unlisten lister
    end;
    begin match !key_up_listener with
      | None -> ()
      | Some lister -> Ev.unlisten lister
    end;
    begin match !script_processor with
      | None -> ()
      | Some proc -> Web_audio.AudioNode.disconnect (Web_audio.ScriptProcessorNode.as_node proc)
    end;
    script_processor := None
end

let set_up_keyboard (type a) (module C : Camlboy_intf.S with type t = a) (t : a) =
  let key_down_fun ev =
    let key_ev = Ev.as_type ev in
    let key_name = key_ev |> Ev.Keyboard.key |> Jstr.to_string in
    match key_name with
    | "Enter" -> C.press t Start
    | "Shift" -> C.press t Select
    | "j"     -> C.press t B
    | "k"     -> C.press t A
    | "w"     -> C.press t Up
    | "a"     -> C.press t Left
    | "s"     -> C.press t Down
    | "d"     -> C.press t Right
    | _       -> ()
  in
  let key_up_fun ev =
    let key_ev = Ev.as_type ev in
    let key_name = key_ev |> Ev.Keyboard.key |> Jstr.to_string in
    match key_name with
    | "Enter" -> C.release t Start
    | "Shift" -> C.release t Select
    | "j"     -> C.release t B
    | "k"     -> C.release t A
    | "w"     -> C.release t Up
    | "a"     -> C.release t Left
    | "s"     -> C.release t Down
    | "d"     -> C.release t Right
    | _       -> ()
  in
  let key_down_listener = Ev.listen Ev.keydown (key_down_fun) G.target in
  let key_up_listener = Ev.listen Ev.keyup (key_up_fun) G.target in
  State.set_listener key_down_listener key_up_listener

let set_up_joypad (type a) (module C : Camlboy_intf.S with type t = a) (t : a) =
  let up_el, down_el, left_el, right_el =
    find_el_by_id "up", find_el_by_id "down", find_el_by_id "left", find_el_by_id "right" in
  let a_el, b_el = find_el_by_id "a", find_el_by_id "b" in
  let start_el, select_el = find_el_by_id "start", find_el_by_id "select" in
  let viberate ms =
    let navigator = G.navigator |> Navigator.to_jv in
    ignore @@ Jv.call navigator "vibrate" Jv.[| of_int ms |]
  in
  (* TODO: unlisten these listener on rom change *)
  let press ev t key = Ev.prevent_default ev; viberate 10; C.press t key in
  let release ev t key = Ev.prevent_default ev; C.release t key in
  let listen_ops = Ev.listen_opts ~capture:true () in
  let (_ : Ev.listener) = Ev.listen My_ev.touchstart ~opts:listen_ops (fun ev -> press ev t Up)     (El.as_target up_el) in
  let (_ : Ev.listener) = Ev.listen My_ev.touchstart ~opts:listen_ops (fun ev -> press ev t Down)   (El.as_target down_el) in
  let (_ : Ev.listener) = Ev.listen My_ev.touchstart ~opts:listen_ops (fun ev -> press ev t Left)   (El.as_target left_el) in
  let (_ : Ev.listener) = Ev.listen My_ev.touchstart ~opts:listen_ops (fun ev -> press ev t Right)  (El.as_target right_el) in
  let (_ : Ev.listener) = Ev.listen My_ev.touchstart ~opts:listen_ops (fun ev -> press ev t A)      (El.as_target a_el) in
  let (_ : Ev.listener) = Ev.listen My_ev.touchstart ~opts:listen_ops (fun ev -> press ev t B)      (El.as_target b_el) in
  let (_ : Ev.listener) = Ev.listen My_ev.touchstart ~opts:listen_ops (fun ev -> press ev t Start)  (El.as_target start_el) in
  let (_ : Ev.listener) = Ev.listen My_ev.touchstart ~opts:listen_ops (fun ev -> press ev t Select) (El.as_target select_el) in
  let (_ : Ev.listener) = Ev.listen My_ev.touchend ~opts:listen_ops (fun ev -> release ev t Up)     (El.as_target up_el) in
  let (_ : Ev.listener) = Ev.listen My_ev.touchend ~opts:listen_ops (fun ev -> release ev t Down)   (El.as_target down_el) in
  let (_ : Ev.listener) = Ev.listen My_ev.touchend ~opts:listen_ops (fun ev -> release ev t Left)   (El.as_target left_el) in
  let (_ : Ev.listener) = Ev.listen My_ev.touchend ~opts:listen_ops (fun ev -> release ev t Right)  (El.as_target right_el) in
  let (_ : Ev.listener) = Ev.listen My_ev.touchend ~opts:listen_ops (fun ev -> release ev t A)      (El.as_target a_el) in
  let (_ : Ev.listener) = Ev.listen My_ev.touchend ~opts:listen_ops (fun ev -> release ev t B)      (El.as_target b_el) in
  let (_ : Ev.listener) = Ev.listen My_ev.touchend ~opts:listen_ops (fun ev -> release ev t Start)  (El.as_target start_el) in
  let (_ : Ev.listener) = Ev.listen My_ev.touchend ~opts:listen_ops (fun ev -> release ev t Select) (El.as_target select_el) in
  ()

let throttled = ref true
let audio_enabled = ref false

(* FPS counter helper - same pattern as SDL2 frontend *)
type fps_counter = {
  mutable frame_count : int;
  mutable start_time : float;
}

let create_fps_counter () =
  { frame_count = 0; start_time = Performance.now_ms G.performance }

let update_fps_counter counter ~on_tick =
  counter.frame_count <- counter.frame_count + 1;
  if counter.frame_count = 60 then begin
    let now = Performance.now_ms G.performance in
    let fps = 60. /. ((now -. counter.start_time) /. 1000.) in
    on_tick fps;
    counter.start_time <- now;
    counter.frame_count <- 0
  end

let set_fps_text text =
  let fps_el = find_el_by_id "fps" in
  El.set_children fps_el [El.txt (Jstr.v text)]

(* Audio-driven main loop - audio callback drives emulation.
   Similar to SDL2's main_audio_sync but simpler since ScriptProcessorNode
   runs on the main thread (no mutex needed). *)
let run_rom_bytes_with_audio ctx image_data rom_bytes =
  State.clear ();
  let cartridge = Detect_cartridge.f ~rom_bytes in
  let module C = Camlboy.Make(val cartridge) in
  let t = C.create_with_rom ~print_serial_port:true ~rom_bytes () in
  set_up_keyboard (module C) t;
  set_up_joypad (module C) t;
  let apu = C.get_apu t in
  let sample_rate = Apu.sample_rate apu in
  let buffer_capacity = Apu.buffer_capacity apu in
  (* Use a third of the capacity for script processor buffer *)
  let processor_buffer_size = buffer_capacity / 3 in
  (* Create audio context with APU's sample rate *)
  let audio_ctx = match !State.audio_context with
    | Some ctx -> ctx
    | None ->
      let ctx = Web_audio.AudioContext.create ~sample_rate () in
      State.audio_context := Some ctx;
      ctx
  in
  (* Create script processor for audio callback *)
  let processor = Web_audio.AudioContext.create_script_processor
      audio_ctx
      ~buffer_size:processor_buffer_size
      ~input_channels:0
      ~output_channels:2
  in
  State.script_processor := Some processor;
  let fps_counter = create_fps_counter () in
  (* Stats for frames per audio callback *)
  let total_frames = ref 0 in
  let total_callbacks = ref 0 in
  (* Audio callback - drives emulation and rendering.
     Called by browser when audio samples are needed. *)
  Web_audio.ScriptProcessorNode.set_onaudioprocess processor (fun ev ->
    let output_buffer = Web_audio.ScriptProcessorNode.AudioProcessingEvent.output_buffer ev in
    let left_channel = Web_audio.AudioBuffer.get_channel_data output_buffer 0 in
    let right_channel = Web_audio.AudioBuffer.get_channel_data output_buffer 1 in
    let samples_needed = Jv.Jarray.length left_channel in
    let frames_this_callback = ref 0 in
    (* Run emulation until we have enough samples *)
    while Apu.samples_available apu < samples_needed do
      begin match C.run_instruction t with
        | In_frame -> ()
        | Frame_ended fb ->
          incr frames_this_callback;
          draw_framebuffer ctx image_data fb;
          update_fps_counter fps_counter ~on_tick:(fun fps ->
            let avg_frames = if !total_callbacks > 0
              then float_of_int !total_frames /. float_of_int !total_callbacks
              else 0.0 in
            set_fps_text (Printf.sprintf "%.1f (%.2f f/cb)" fps avg_frames))
      end
    done;
    (* Update callback stats *)
    total_frames := !total_frames + !frames_this_callback;
    incr total_callbacks;
    (* Pop samples from APU and convert int16 to float32 *)
    for i = 0 to samples_needed - 1 do
      match Apu.pop_sample apu with
      | Some sample ->
        (* Convert from int16 range [-32768, 32767] to float [-1.0, 1.0] *)
        let left = Jv.of_float (float_of_int sample.left /. 32768.0) in
        let right = Jv.of_float (float_of_int sample.right /. 32768.0) in
        Jv.Jarray.set left_channel i left;
        Jv.Jarray.set right_channel i right
      | None ->
        (* Buffer underrun - output silence *)
        Jv.Jarray.set left_channel i (Jv.of_float 0.0);
        Jv.Jarray.set right_channel i (Jv.of_float 0.0)
    done
  );
  (* Connect to destination *)
  let dest = Web_audio.AudioContext.destination audio_ctx in
  Web_audio.AudioNode.connect
    (Web_audio.ScriptProcessorNode.as_node processor)
    (Web_audio.AudioDestinationNode.as_node dest);
  (* Resume audio context (needed after user interaction) *)
  Fut.await (Web_audio.AudioContext.resume audio_ctx) (fun _ -> ())

(* Frame-driven main loop - requestAnimationFrame drives emulation *)
let run_rom_bytes_no_audio ctx image_data rom_bytes =
  State.clear ();
  let cartridge = Detect_cartridge.f ~rom_bytes in
  let module C = Camlboy.Make(val cartridge) in
  let t = C.create_with_rom ~print_serial_port:true ~rom_bytes () in
  set_up_keyboard (module C) t;
  set_up_joypad (module C) t;
  let fps_counter = create_fps_counter () in
  let rec main_loop () =
    begin match C.run_instruction t with
      | In_frame ->
        main_loop ()
      | Frame_ended fb ->
        update_fps_counter fps_counter ~on_tick:(fun fps ->
          set_fps_text (Printf.sprintf "%.1f" fps));
        draw_framebuffer ctx image_data fb;
        if not !throttled then
          State.run_id := Some (G.set_timeout ~ms:0 main_loop)
        else
          State.run_id := Some (G.request_animation_frame (fun _ -> main_loop ()))
    end;
  in
  main_loop ()

let run_rom_bytes ctx image_data rom_bytes =
  if !audio_enabled then
    run_rom_bytes_with_audio ctx image_data rom_bytes
  else
    run_rom_bytes_no_audio ctx image_data rom_bytes

let run_rom_blob ctx image_data rom_blob =
  let* result = Blob.array_buffer rom_blob in
  match result with
  | Ok buf ->
    let rom_bytes =
      Tarray.of_buffer Uint8 buf
      |> Tarray.to_bigarray1
      (* Convert uint8 bigarray to char bigarray *)
      |> Obj.magic
    in
    Fut.return @@ run_rom_bytes ctx image_data rom_bytes
  | Error e ->
    Fut.return @@ Console.(log [Jv.Error.message e])

let on_load_rom ctx image_data input_el =
  let file = El.Input.files input_el |> List.hd in
  let blob = File.as_blob file in
  Fut.await (run_rom_blob ctx image_data blob) (fun () -> ())

let run_selected_rom ctx image_data rom_path =
  let* result = Fetch.url (Jstr.v rom_path) in
  match result with
  | Ok response ->
    let body = Fetch.Response.as_body response in
    let* result = Fetch.Body.blob body in
    begin match result with
      | Ok blob -> run_rom_blob ctx image_data blob
      | Error e  -> Fut.return @@ Console.(log [Jv.Error.message e])
    end
  | Error e  -> Fut.return @@ Console.(log [Jv.Error.message e])

let set_up_rom_selector ctx image_data selector_el =
  rom_options
  |> List.map (fun rom_option ->
      El.option
        ~at:At.[value (Jstr.v rom_option.path)]
        [El.txt' rom_option.name])
  |> El.append_children selector_el;
  let on_change _ =
    let rom_path = El.prop (El.Prop.value) selector_el |> Jstr.to_string in
    Fut.await (run_selected_rom ctx image_data rom_path) (fun () -> ())
  in
  let (_ : Ev.listener) = Ev.listen Ev.change on_change (El.as_target selector_el) in
  ()

let set_default_throttle_val checkbox_el =
  let uri = Window.location G.window in
  let param =
    uri
    |> Uri.query
    |> Uri.Params.of_jstr
    |> Uri.Params.find Jstr.(v "throttled")
  in
  let set_throttled_val b =
    El.set_prop (El.Prop.checked) b checkbox_el;
    throttled := b
  in
  match param with
  | Some jstr ->
    begin match Jstr.to_string jstr with
      | "false" -> set_throttled_val false
      | _      -> set_throttled_val true
    end
  | None -> set_throttled_val true

let on_throttle_change checkbox_el =
  let checked = El.prop (El.Prop.checked) checkbox_el in
  throttled := checked

let on_audio_change ctx image_data checkbox_el =
  let checked = El.prop (El.Prop.checked) checkbox_el in
  audio_enabled := checked;
  (* Reload current ROM to apply audio change *)
  let selector_el = find_el_by_id "rom-selector" in
  let rom_path = El.prop (El.Prop.value) selector_el |> Jstr.to_string in
  Fut.await (run_selected_rom ctx image_data rom_path) (fun () -> ())

let () =
  (* Set up canvas *)
  let canvas = find_el_by_id "canvas" |> Canvas.of_el in
  let ctx = C2d.get_context canvas in
  C2d.scale ctx ~sx:1.5 ~sy:1.5;
  let image_data = C2d.create_image_data ctx ~w:gb_w ~h:gb_h in
  let fb = Array.make_matrix gb_h gb_w `Light_gray in
  draw_framebuffer ctx image_data fb;
  (* Set up throttle checkbox *)
  let throttle_el = find_el_by_id "throttle" in
  set_default_throttle_val throttle_el;
  let (_ : Ev.listener) = Ev.listen Ev.change (fun _ -> on_throttle_change throttle_el) (El.as_target throttle_el) in
  (* Set up audio checkbox *)
  let audio_el = find_el_by_id "audio" in
  let (_ : Ev.listener) = Ev.listen Ev.change (fun _ -> on_audio_change ctx image_data audio_el) (El.as_target audio_el) in
  (* Set up load rom button *)
  let input_el = find_el_by_id "load-rom" in
  let (_ : Ev.listener) = Ev.listen Ev.change (fun _ -> on_load_rom ctx image_data input_el) (El.as_target input_el) in
  (* Set up rom selector *)
  let selector_el = find_el_by_id "rom-selector" in
  set_up_rom_selector ctx image_data selector_el;
  (* Load initial rom *)
  let rom = List.hd rom_options in
  let fut = run_selected_rom ctx image_data rom.path in
  Fut.await fut (fun () -> ())
