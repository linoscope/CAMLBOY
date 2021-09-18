open Uints

(* mclock = 1048576 Hz while divider counts up at 262144 Hz, so  1048576 / 262144 = 4*)
let mcycle_per_count = 4

type t = {
  addr : uint16;
  mutable count : int;
  mutable uncounted_cycles : int;
}

let create addr = { addr; count = 0; uncounted_cycles = 0 }

let run t ~cycles =
  t.uncounted_cycles <- t.uncounted_cycles + cycles;
  if t.uncounted_cycles >= mcycle_per_count then begin
    t.uncounted_cycles <- t.uncounted_cycles - mcycle_per_count;
    t.count <- t.count + 1;
    if t.count >= 0xFF then begin
      t.count <- 0
    end
  end

let accepts t addr = Uint16.(addr = t.addr)

let read_byte t addr =
  if accepts t addr then
    t.count |> Uint8.of_int
  else
    raise @@ Invalid_argument "Address out of bounds"

let write_byte t ~addr ~data:_ =
  if accepts t addr then
    (* write to divider register resets it to 0 *)
    t.count <- 0
  else
    raise @@ Invalid_argument "Address out of bounds"
