open Camlboy_lib
open Uints

module Make (Cartridge : Cartridge_intf.S) = struct
  module Camlboy = Camlboy.Make (Cartridge)

  let run_test_rom_and_print_framebuffer file =
    let rom_bytes = Read_rom_file.f file  in
    let camlboy = Camlboy.create_with_rom ~rom_bytes ~print_serial_port:false in
    let rec loop () =
      let run_result = Camlboy.run_instruction camlboy in
      let prev_instr = Camlboy.For_tests.prev_inst camlboy in
      match prev_instr, run_result with
      | JR (None, i8), Frame_ended famebuffer ->
        if Int8.to_int i8 <> -3 then
          loop ()
        else begin
          Printf.printf "%s\n" @@ Camlboy.show camlboy;
          famebuffer
          |> Array.iteri (fun i row ->
              if row |> Array.for_all (fun color -> color = `White) then
                ()
              else begin
                let show_color = function
                  | `Black -> '#'
                  | `Dark_gray -> '@'
                  | `Light_gray -> 'x'
                  | `White -> '-'
                in
                Printf.printf "%03d:" i;
                row |> Array.iter (fun color -> show_color color |> print_char);
                print_newline ()
              end
            )
        end
      | _, _ -> loop ()
    in
    loop ()
end
