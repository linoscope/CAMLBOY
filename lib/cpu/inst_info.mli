open Uints

type mcycles = {
  not_branched : int;
  branched : int;
}

type t = {
  len : uint16;
  mcycles : mcycles;
  inst : Instruction.t;
}
