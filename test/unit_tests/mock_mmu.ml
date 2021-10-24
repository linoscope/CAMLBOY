open Camlboy_lib
open Uints

type t = Bigstringaf.t

let create ~size = Bigstringaf.create size

(* let load t ~src ~dst_pos =
 *   Bytes.blit ~src ~src_pos:0 ~dst:t ~dst_pos:(Uint16.to_int dst_pos) ~len:(Bytes.length src) *)

let load t ~src ~dst_pos =
  Bigstringaf.blit src ~src_off:0 t ~dst_off:(Uint16.to_int dst_pos) ~len:(Bigstringaf.length src)

let read_byte t addr =
  let addr = Uint16.to_int addr in
  Bigstringaf.get t addr |> Uint8.of_char

let read_word t addr =
  let addr = Uint16.to_int addr in
  Bigstringaf.get_int16_le t addr |> Uint16.of_int

let write_byte t ~addr ~data =
  Bigstringaf.set t (Uint16.to_int addr) (Uint8.to_char data)

let write_word t ~addr ~data =
  Bigstringaf.set_int16_le t (Uint16.to_int addr) (Uint16.to_int data)

let accepts _ _ = true

(* let dump t =
 *   t |> Bytes.iter ~f:(fun c -> Char.code c |> Printf.printf "%02x ") *)
let dump t =
  for i = 0 to Bigstringaf.length t - 1 do
    let c = Bigstringaf.get t i |> Char.code in
    Printf.printf "%02x " c
  done

let%expect_test "read then write" =
  let t = create ~size:10 in
  write_byte t ~addr:Uint16.(of_int 0x07) ~data:Uint8.(of_int 0xAA);
  read_byte t Uint16.(of_int 0x07) |> Uint8.show |> print_endline;

  [%expect {| $AA |}]
