open Uints

type t = {
  bytes : Bigstringaf.t;
  start_addr : uint16;
  end_addr : uint16;
}

let create ~start_addr ~end_addr =
  let string = String.init Uint16.(to_int @@ end_addr - start_addr + one) (fun _ -> Char.chr 0) in
  let bytes = Bigstringaf.of_string ~off:0 ~len:(String.length string) string in
  {
    bytes;
    start_addr;
    end_addr;
  }

let accepts t addr = Uint16.(t.start_addr <= addr && addr <= t.end_addr)

let read_byte t addr =
  let offset = Uint16.(addr - t.start_addr) |> Uint16.to_int in
  Bigstringaf.get t.bytes offset |> Uint8.of_char

let write_byte t ~addr ~data =
  let offset = Uint16.(addr - t.start_addr) |> Uint16.to_int in
  Bigstringaf.set t.bytes offset (Uint8.to_char data)
