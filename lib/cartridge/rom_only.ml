open Uints
module Bytes = BytesLabels

type t = {
  bytes : bytes;
  start_addr : uint16;
  end_addr : uint16;
}

let create ~rom_bytes ~start_addr ~end_addr = {
  bytes = rom_bytes;
  start_addr;
  end_addr;
}

let read_byte t addr =
  let offset = Uint16.(addr - t.start_addr) |> Uint16.to_int in
  Bytes.get_int8 t.bytes offset |> Uint8.of_int

let write_byte _ ~addr:_ ~data:_ = ()
(* Some games such as tetris write to rom.
 * We do not want the whole game to fail for such cases so we don't throw exception here.
 * https://www.reddit.com/r/EmuDev/comments/5ht388/gb_why_does_tetris_write_to_the_rom/ *)

let accepts t addr = Uint16.(t.start_addr <= addr && addr <= t.end_addr)
