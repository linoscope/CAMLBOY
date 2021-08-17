open Ints

type t = {
  registers : Registers.t;
  mutable pc : uint16;
  mutable sp : uint16;
  memory : Memory.t;
}
[@@deriving show]

let create memory = {
  registers = Registers.create ();
  pc = Uint16.zero;
  sp = Uint16.zero;
  memory
}

(** Functions for processing 8 bit load/arithmic operations such as "LD B, 0xAB" *)
module Eight_bit_mode = struct
  let (<--) (x : Instruction.arg) (y : uint8) (t : t) : unit =
    match x with
    | R r -> Registers.write_r t.registers r y
    | RR_indirect rr ->
      let addr = Registers.read_rr t.registers rr in
      Memory.write_byte t.memory ~addr ~data:y
    | _ -> assert false

  let read (x : Instruction.arg) (t : t) : uint8 =
    match x with
    | Immediate n -> n
    | Direct addr -> Memory.read_byte t.memory addr
    | R r -> Registers.read_r t.registers r
    | RR_indirect rr ->
      let addr = Registers.read_rr t.registers rr in
      Memory.read_byte t.memory addr
    | FF00_offset n ->
      let addr = Uint16.(of_int 0xFF00 + of_uint8 n) in
      Memory.read_byte t.memory addr
    | FF00_C ->
      let c = Registers.read_r t.registers C in
      let addr = Uint16.(of_int 0xFF00 + of_uint8 c) in
      Memory.read_byte t.memory addr
    | HL_inc
    | HL_dec ->
      let addr = Registers.read_rr t.registers HL in
      Memory.read_byte t.memory addr
end

(** Functions for processing 16 bit load/arithmic operations such as "LD BC, 0xABCD" *)
module Sixteen_bit_mode = struct
  let (<--) (x : Instruction.arg16) (y : uint16) (t : t) : unit =
    match x with
    | RR rr -> Registers.write_rr t.registers rr y
    | _ -> assert false

  let read (x : Instruction.arg16) (t : t) : uint16 =
    match x with
    | Immediate n -> n
    | RR rr -> Registers.read_rr t.registers rr
    | _ -> assert false
end

type next_pc = Next | Jump of uint16

let execute (t : t) (inst_len : uint16) (inst : Instruction.t) : unit =
  let check_condition t : Instruction.condition -> bool = function
    | None -> true
    | Z -> Registers.read_flag t.registers Zero
    | NZ -> not (Registers.read_flag t.registers Zero)
    | C -> Registers.read_flag t.registers Carry
    | NC -> not (Registers.read_flag t.registers Carry)
  in
  let open Eight_bit_mode in
  let module SBM = Sixteen_bit_mode in
  let next_pc = match inst with
    | LD (x, y) -> (x <-- read y t) t; Next
    | SUB (x, y) -> (x <-- Uint8.(read x t - read y t)) t; Next
    | ADD (x, y) -> (x <-- Uint8.(read x t + read y t)) t; Next
    | INC x -> (x <-- Uint8.(read x t + one)) t; Next
    | LD16 (x, y) -> let open SBM in (x <-- read y t) t; Next
    | ADD16 (x, y) -> let open SBM in (x <-- Uint16.(read x t + read y t)) t; Next
    | INC16 x -> let open SBM in (x <-- Uint16.(read x t + one)) t; Next
    | DEC16 x -> let open SBM in (x <-- Uint16.(read x t - one)) t; Next
    | JR (c, x) -> if check_condition t c then Jump Uint16.(t.pc + of_uint8 x) else Next
    | CALL (c, x) -> if check_condition t c then Jump x else Next
    | JP (c, x) -> if check_condition t c then Jump SBM.(read x t) else Next
    | _ -> failwith "Not implemented"
  in
  match next_pc with
  | Next -> t.pc <- Uint16.(t.pc + inst_len)
  | Jump addr -> t.pc <- addr

let tick t  =
  Instruction.fetch t.memory ~pc:t.pc
  |> (fun (inst_len, inst) -> execute t inst_len inst)

module For_tests = struct
  let execute = execute
  let create ~memory ~registers ~sp ~pc = {registers; memory; sp; pc}
end
