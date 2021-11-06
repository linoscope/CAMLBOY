open Camlboy_lib
open Brr
open Brr_canvas

let gb_w = 160
let gb_h = 144

let find_el_by_id id = Document.find_el_by_id G.document (Jstr.v id) |> Option.get

let draw_framebuffer ctx image_data fb =
  let d = C2d.Image_data.data image_data in
  for y = 0 to gb_h - 1 do
    for x = 0 to gb_w - 1 do
      let off = 4 * (y * gb_w + x) in
      match fb.(y).(x) with
      | `White ->
        Tarray.set d (off    ) 0xF0;
        Tarray.set d (off + 1) 0xF0;
        Tarray.set d (off + 2) 0xF0;
        Tarray.set d (off + 3) 0xFF;
      | `Light_gray ->
        Tarray.set d (off    ) 0x94;
        Tarray.set d (off + 1) 0x94;
        Tarray.set d (off + 2) 0x94;
        Tarray.set d (off + 3) 0xFF;
      | `Dark_gray ->
        Tarray.set d (off    ) 0x52;
        Tarray.set d (off + 1) 0x52;
        Tarray.set d (off + 2) 0x52;
        Tarray.set d (off + 3) 0xFF;
      | `Black ->
        Tarray.set d (off    ) 0x00;
        Tarray.set d (off + 1) 0x00;
        Tarray.set d (off + 2) 0x00;
        Tarray.set d (off + 3) 0xFF;
    done
  done;
  C2d.put_image_data ctx image_data ~x:0 ~y:0

let fps_el = find_el_by_id "fps"

let set_fps fps =
  let fps_str = Printf.sprintf "%.2f" fps in
  El.set_children fps_el [El.txt (Jstr.v fps_str)]

let run_rom rom_bytes ctx image_data =
  let cartridge = Detect_cartridge.f ~rom_bytes in
  let module C = Camlboy.Make(val cartridge) in
  let t =  C.create_with_rom ~print_serial_port:true ~rom_bytes in
  let cnt = ref 0 in
  let start_time = ref (Performance.now_ms G.performance) in
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
  ignore @@ G.set_interval ~ms:1 main_loop

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
  let fb = Array.make_matrix gb_h gb_w `Dark_gray in
  draw_framebuffer ctx image_data fb;
  (* Set up load rom button *)
  let input_el = find_el_by_id "load-rom" in
  Ev.listen Ev.change (fun _ -> on_rom_change ctx image_data input_el) (El.as_target input_el);
  (* Set up joypad input *)
