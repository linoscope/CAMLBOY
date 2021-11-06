open Camlboy_lib
open Brr
open Brr_canvas

let gb_w = 160
let gb_h = 144

let alert v =
  let alert = Jv.get Jv.global "alert" in
  ignore @@ Jv.apply alert Jv.[| of_string v |]

let find_el_by_id id = Document.find_el_by_id G.document (Jstr.v id) |> Option.get

let draw_framebuffer ctx image_data fb =
  let d = C2d.Image_data.data image_data in
  for y = 0 to gb_h - 1 do
    for x = 0 to gb_w - 1 do
      let off = 4 * (y * gb_w + x) in
      match fb.(y).(x) with
      | `White ->
        Tarray.set d (off    ) 0xE5;
        Tarray.set d (off + 1) 0xFB;
        Tarray.set d (off + 2) 0xF4;
        Tarray.set d (off + 3) 0xFF;
      | `Light_gray ->
        Tarray.set d (off    ) 0x97;
        Tarray.set d (off + 1) 0xAE;
        Tarray.set d (off + 2) 0xB8;
        Tarray.set d (off + 3) 0xFF;
      | `Dark_gray ->
        Tarray.set d (off    ) 0x61;
        Tarray.set d (off + 1) 0x68;
        Tarray.set d (off + 2) 0x7D;
        Tarray.set d (off + 3) 0xFF;
      | `Black ->
        Tarray.set d (off    ) 0x22;
        Tarray.set d (off + 1) 0x1E;
        Tarray.set d (off + 2) 0x31;
        Tarray.set d (off + 3) 0xFF;
    done
  done;
  C2d.put_image_data ctx image_data ~x:0 ~y:0

(** Manages state that need to be re-set when loading a new rom *)
module State = struct
  let run_id = ref None
  let key_down_listener = ref None
  let key_up_listener = ref None
  let set id down up =
    run_id := Some id;
    key_down_listener := Some down;
    key_up_listener := Some up
  let clear () =
    begin match !run_id with
      | None -> ()
      | Some timer_id ->
        G.stop_timer timer_id
    end;
    begin match !key_down_listener with
      | None -> ()
      | Some lister -> Ev.unlisten Ev.keydown lister G.target
    end;
    begin match !key_up_listener with
      | None -> ()
      | Some lister -> Ev.unlisten Ev.keyup lister G.target
    end;
end

let run_rom rom_bytes ctx image_data =
  State.clear ();
  let cartridge = Detect_cartridge.f ~rom_bytes in
  let module C = Camlboy.Make(val cartridge) in
  let t =  C.create_with_rom ~print_serial_port:true ~rom_bytes in
  let key_down_listener ev =
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
    | _ -> ()
  in
  let key_up_listener ev =
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
    | _ -> ()
  in
  Ev.listen Ev.keydown (key_down_listener) G.target;
  Ev.listen Ev.keyup (key_up_listener) G.target;
  let cnt = ref 0 in
  let start_time = ref (Performance.now_ms G.performance) in
  let set_fps fps =
    let fps_str = Printf.sprintf "%.2f" fps in
    let fps_el = find_el_by_id "fps" in
    El.set_children fps_el [El.txt (Jstr.v fps_str)]
  in
  let rec main_loop () =
    begin match C.run_instruction t with
      | In_frame ->
        main_loop ()
      | Frame_ended fb ->
        incr cnt;
        if !cnt = 60 then begin
          let end_time = Performance.now_ms G.performance in
          let sec_per_60_frame = (end_time -. !start_time) /. 1000. in
          let fps = 60. /.  sec_per_60_frame in
          start_time := end_time;
          set_fps fps;
          Console.(log [fps]);
          cnt := 0;
        end;
        draw_framebuffer ctx image_data fb;
    end;
  in
  let run_id = G.set_interval ~ms:1 main_loop in
  State.set run_id key_down_listener key_up_listener

let on_rom_change ctx image_data input_el =
  let file = El.Input.files input_el |> List.hd in
  let blob = File.as_blob file in
  let buf_fut = Blob.array_buffer blob in
  Fut.await buf_fut (function
      | Ok buf ->
        let rom_bytes =
          Tarray.of_buffer Uint8 buf
          |> Tarray.to_bigarray1
          (* Convert uint8 bigarray to char bigarray *)
          |> Obj.magic
        in
        run_rom rom_bytes ctx image_data
      | Error e ->
        Console.(log [Jv.Error.message e]))

let () =
  (* Set up canvas *)
  let canvas = find_el_by_id "canvas" |> Canvas.of_el in
  let ctx = C2d.create canvas in
  let image_data = C2d.create_image_data ctx ~w:gb_w ~h:gb_h in
  let fb = Array.make_matrix gb_h gb_w `Light_gray in
  draw_framebuffer ctx image_data fb;
  (* Set up load rom button *)
  let input_el = find_el_by_id "load-rom" in
  Ev.listen Ev.change (fun _ -> on_rom_change ctx image_data input_el) (El.as_target input_el);
  (* Set up joypad input *)
