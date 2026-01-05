open Camlboy_lib
open Brr
open Brr_io
open Fut.Syntax

let find_el_by_id id = Document.find_el_by_id G.document (Jstr.v id) |> Option.get

let run_rom_bytes rom_bytes frames =
  let cartridge = Detect_cartridge.f ~rom_bytes in
  let module C = Camlboy.Make(val cartridge) in
  let t =  C.create_with_rom ~print_serial_port:false ~rom_bytes () in
  let frame_count = ref 0 in
  let start_time = ref (Performance.now_ms G.performance) in
  while !frame_count < frames do
    match C.run_instruction t with
    | In_frame -> ()
    | Frame_ended _ -> incr frame_count
  done;
  (Performance.now_ms G.performance) -. !start_time

let run_rom_blob rom_blob frames =
  let+ result = Blob.array_buffer rom_blob in
  match result with
  | Ok buf ->
    let rom_bytes =
      Tarray.of_buffer Uint8 buf
      |> Tarray.to_bigarray1
      (* Convert uint8 bigarray to char bigarray *)
      |> Obj.magic
    in
    run_rom_bytes rom_bytes frames
  | Error e ->
    Console.(log [Jv.Error.message e]);
    0.

let run_rom_path rom_path frames =
  let* result = Fetch.url (Jstr.v rom_path) in
  match result with
  | Ok response ->
    let body = Fetch.Response.as_body response in
    let* result = Fetch.Body.blob body in
    begin match result with
      | Ok blob ->
        run_rom_blob blob frames
      | Error e  ->
        Console.(log [Jv.Error.message e]);
        Fut.return 0.
    end
  | Error e  ->
    Console.(log [Jv.Error.message e]);
    Fut.return 0.

let read_param param_key ~default =
  let uri = Window.location G.window in
  let param =
    uri
    |> Uri.query
    |> Uri.Params.of_jstr
  in
  match Uri.Params.find Jstr.(v param_key) param with
  | Some jstr -> Jstr.to_string jstr
  | None -> default

let main () =
  (* Read URL parameters *)
  let rom_path = read_param "rom_path" ~default:"tobu.gb" in
  let frames = read_param "frames" ~default:"1500" |> int_of_string in
  (* Load initial rom *)
  let+ duration_ms = run_rom_path rom_path frames in
  let duration = duration_ms /. 1000. in
  let fps = Float.(of_int frames /. duration) in
  let msg = Printf.sprintf "%8s: %s\n%8s: %d\n%8s: %f\n%8s: %f\n"
      "ROM path" rom_path
      "Frames" frames
      "Duration" duration
      "FPS" fps
  in
  let result_el = find_el_by_id "bench_result" in
  El.set_children result_el [El.txt (Jstr.v msg)]

let () = Fut.await (main ()) Fun.id
