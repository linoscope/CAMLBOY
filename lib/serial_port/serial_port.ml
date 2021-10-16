open Uints

type t = {
  sb : Mmap_register.t;         (* Serial transfer data *)
  sc : Mmap_register.t;         (* Serial transfer control *)
  print_serial_port : bool;
}

let create ~sb ~sc ?(print_serial_port = false) () = {sb; sc; print_serial_port;}

let read_byte t addr =
  match addr with
  | _ when Mmap_register.accepts t.sb addr -> Mmap_register.read_byte t.sb addr
  | _ when Mmap_register.accepts t.sc addr -> Mmap_register.read_byte t.sc addr
  | _ -> failwith "invalid addr"

let write_byte t ~addr ~data =
  match addr with
  | _ when Mmap_register.accepts t.sb addr -> Mmap_register.write_byte t.sb ~addr ~data
  | _ when Mmap_register.accepts t.sc addr ->
    Mmap_register.write_byte t.sc ~addr ~data;
    if t.print_serial_port && Uint8.(data = of_int 0x81) then begin
      Printf.printf "%c" Uint8.(Mmap_register.peek t.sb |> to_int |> Char.unsafe_chr);
      flush_all ();
    end
  | _ -> failwith "invalid addr"

let accepts t addr =
  Mmap_register.accepts t.sb addr || Mmap_register.accepts t.sc addr
