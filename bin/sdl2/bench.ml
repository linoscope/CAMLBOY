open Camlboy_lib

let run ~rom_bytes ~frames =
  let cartridge = Detect_cartridge.f ~rom_bytes in
  let module Camlboy = Camlboy.Make (val cartridge) in
  let camlboy = Camlboy.create_with_rom ~rom_bytes ~print_serial_port:false in
  let frame_count = ref 0 in
  let start_time = ref (Unix.gettimeofday ()) in
  while !frame_count < frames do
    begin match Camlboy.run_instruction camlboy with
      | In_frame -> ()
      | Frame_ended _ -> incr frame_count
    end;
  done;
  Unix.gettimeofday () -. !start_time


let () =
  let usage_msg = "bench.exe [--frames <frames>] <rom_path>" in
  let frames = ref 1000 in
  let rom_path = ref "./resource/games/tobu.gb" in
  let spec = [("--frames", Arg.Set_int frames,  "Number of frames to run")] in
  Arg.parse spec (fun path -> rom_path := path) usage_msg;
  let rom_bytes = Read_rom_file.f !rom_path in
  let duration = run ~rom_bytes ~frames:!frames in
  let fps = Float.(of_int !frames) /. duration in
  Printf.printf "%8s: %s\n%8s: %d\n%8s: %f\n%8s: %f\n"
    "ROM path" !rom_path
    "Frames" !frames
    "Duration" duration
    "FPS" fps
