open Ints

type t = {
  registers : Registers.t;
  pc : uint16;
  memory : Memory.t;
}
