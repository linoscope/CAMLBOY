open Camlboy_lib

let () =
  let camlboy = Camlboy.create () in
  while true do
    Camlboy.tick camlboy;
    Printf.printf "%s\n" (Camlboy.show camlboy);
  done
