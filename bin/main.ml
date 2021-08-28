open Camlboy_lib

let () =
  let camlboy = Camlboy.create () in
  while true do
    Camlboy.tick camlboy
  done
