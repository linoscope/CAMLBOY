open Camlboy_lib
open Brr
open Brr_canvas

let gb_w = 160
let gb_h = 144

let canvas_id = "screen"

let draw_framebuffer ctx image_data fb =
  let d = C2d.Image_data.data image_data in
  for y = 0 to gb_h - 1 do
    for x = 0 to gb_w - 1 do
      let off = 4 * (y * gb_w + x) in
      match fb.(y).(x) with
      | `White ->
        Tarray.set d (off    ) 0xFF;
        Tarray.set d (off + 1) 0xFF;
        Tarray.set d (off + 2) 0xFF;
        Tarray.set d (off + 3) 0xFF;
      | `Light_gray ->
        Tarray.set d (off    ) 0xAA;
        Tarray.set d (off + 1) 0xAA;
        Tarray.set d (off + 2) 0xAA;
        Tarray.set d (off + 3) 0xFF;
      | `Dark_gray ->
        Tarray.set d (off    ) 0x77;
        Tarray.set d (off + 1) 0x77;
        Tarray.set d (off + 2) 0x77;
        Tarray.set d (off + 3) 0xFF;
      | `Black ->
        Tarray.set d (off    ) 0x00;
        Tarray.set d (off + 1) 0x00;
        Tarray.set d (off + 2) 0x00;
        Tarray.set d (off + 3) 0xFF;
    done
  done;
  C2d.put_image_data ctx image_data ~x:0 ~y:0

let load_rom_button ctx image_data =
  let on_change i =
    let file = El.Input.files i |> List.hd in
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
          let cartridge = Detect_cartridge.f ~rom_bytes in
          let module C = Camlboy.Make(val cartridge) in
          let t =  C.create_with_rom ~print_serial_port:true ~rom_bytes in
          Console.profile (Jstr.v "foo");
          let cnt = ref 0 in
          let start_time = ref (Performance.now_ms G.performance) in
          let rec run_instr () =
            begin match C.run_instruction t with
              | In_frame ->
                run_instr ()
              | Frame_ended fb ->
                incr cnt;
                if !cnt = 60 then begin
                  let end_time = Performance.now_ms G.performance in
                  let sec_per_60_frame = (end_time -. !start_time) /. 1000. in
                  let fps = 60. /.  sec_per_60_frame in
                  start_time := end_time;
                  Console.(log [fps]);
                  cnt := 0;
                end;
                draw_framebuffer ctx image_data fb;
            end;
          in
          ignore @@ G.set_interval ~ms:10 run_instr
        | Error e ->
          Console.(log [Jv.Error.message e])
      )
  in
  let i = El.input ~at:At.[type' (Jstr.v "file")] () in
  let b = El.button [ El.txt' "Load Rom" ] in
  El.set_inline_style El.Style.display (Jstr.v "none") i;
  Ev.listen Ev.click (fun _ -> El.click i) (El.as_target b);
  Ev.listen Ev.change (fun _ -> on_change i) (El.as_target i);
  El.span [i; b]

let () =
  let cnv = Canvas.create ~w:gb_w ~h:gb_h ~at:At.[id (Jstr.v canvas_id)] [] in
  let ctx = C2d.create cnv in
  let image_data = C2d.create_image_data ctx ~w:gb_w ~h:gb_h in
  let fb = Array.make_matrix gb_h gb_w `Dark_gray in
  let fb2 = Array.make_matrix gb_h gb_w `Black in
  draw_framebuffer ctx image_data fb;
  draw_framebuffer ctx image_data fb2;
  draw_framebuffer ctx image_data fb;
  El.set_children (Document.body G.document) [
    Canvas.to_el cnv;
    load_rom_button ctx image_data;
  ]
