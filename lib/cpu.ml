open Ints

type t = {
  registers : Registers.t;
  mutable pc : uint16;
  mutable sp : uint16;
  mmu : Mmu.t;
}
[@@deriving show]

let create mmu = {
  registers = Registers.create ();
  pc = Uint16.zero;
  sp = Uint16.zero;
  mmu
}

(** Functions for reading/writing arguments of 8 bit load/arithmic operations
 **  such as "LD B, 0xAB" and "ADD B, 0xAB" *)
module Eight_bit_mode = struct
  let (<--) (x : Instruction.arg) (y : uint8) (t : t) : unit =
    match x with
    | R r -> Registers.write_r t.registers r y
    | RR_indirect rr ->
      let addr = Registers.read_rr t.registers rr in
      Mmu.write_byte t.mmu ~addr ~data:y
    | FF00_offset n ->
      let addr = Uint16.(of_int 0xFF00 + of_uint8 n) in
      Mmu.write_byte t.mmu ~addr ~data:y
    | FF00_C ->
      let c = Registers.read_r t.registers C in
      let addr = Uint16.(of_int 0xFF00 + of_uint8 c) in
      Mmu.write_byte t.mmu ~addr ~data:y
    | HL_inc
    | HL_dec ->
      let addr = Registers.read_rr t.registers HL in
      Mmu.write_byte t.mmu ~addr ~data:y
    | Direct addr -> Mmu.write_byte t.mmu ~addr ~data:y
    | Immediate _ -> failwith @@ Printf.sprintf "Invalid arugment: %s" (Instruction.show_arg x)

  let read (x : Instruction.arg) (t : t) : uint8 =
    match x with
    | Immediate n -> n
    | Direct addr -> Mmu.read_byte t.mmu addr
    | R r -> Registers.read_r t.registers r
    | RR_indirect rr ->
      let addr = Registers.read_rr t.registers rr in
      Mmu.read_byte t.mmu addr
    | FF00_offset n ->
      let addr = Uint16.(of_int 0xFF00 + of_uint8 n) in
      Mmu.read_byte t.mmu addr
    | FF00_C ->
      let c = Registers.read_r t.registers C in
      let addr = Uint16.(of_int 0xFF00 + of_uint8 c) in
      Mmu.read_byte t.mmu addr
    | HL_inc
    | HL_dec ->
      let addr = Registers.read_rr t.registers HL in
      Mmu.read_byte t.mmu addr
end

(** Functions for reading/writing arguments of 16 bit load/arithmic operations
 **  such as "LD BC, 0xABCD" and "ADD BC, 0xABCD" *)
module Sixteen_bit_mode = struct
  let (<--) (x : Instruction.arg16) (y : uint16) (t : t) : unit =
    match x with
    | Direct addr -> Mmu.write_word t.mmu ~addr ~data:y
    | RR rr -> Registers.write_rr t.registers rr y
    | SP -> t.sp <- y
    | Immediate _
    | Immediate8 _
    | SP_offset _ -> failwith @@ Printf.sprintf "Invalid arugment: %s" (Instruction.show_arg16 x)

  let read (x : Instruction.arg16) (t : t) : uint16 =
    match x with
    | Immediate n -> n
    | Immediate8 n -> n |> Uint16.of_uint8
    | Direct addr -> Mmu.read_word t.mmu addr
    | RR rr -> Registers.read_rr t.registers rr
    | SP -> t.sp
    | SP_offset n -> Uint16.(t.sp + of_uint8 n)
end

type next_pc = Next | Jump of uint16

let execute (t : t) (inst_len : uint16) (inst : Instruction.t) : unit =
  let check_condition t : Instruction.condition -> bool = function
    | None -> true
    | Z    -> Registers.read_flag t.registers Zero
    | NZ   -> not (Registers.read_flag t.registers Zero)
    | C    -> Registers.read_flag t.registers Carry
    | NC   -> not (Registers.read_flag t.registers Carry)
  in
  let set_flags = Registers.set_flags t.registers in
  let open Eight_bit_mode in
  let module SBM = Sixteen_bit_mode in
  let next_pc = match inst with
    | LD (x, y) ->
      (x <-- read y t) t;
      Next
    | LD16 (x, y)  ->
      let open SBM in
      (x <-- read y t) t;
      Next
    | ADD (x, y) ->
      let x', y' = read x t, read y t in
      let n = Uint8.(x' + y') in
      set_flags
        ~z:(n = Uint8.zero)
        ~h:Uint8.(x' land of_int 0xF + y' land of_int 0xF > of_int 0xF)
        ~n:false
        ~c:Uint8.(x' > of_int 0xFF - y') ();
      (x <-- n) t;
      Next
    | ADD16 (x, y) ->
      let open SBM in
      let x', y' = read x t, read y t in
      let n = Uint16.(x' + y') in
      set_flags
        ~z:(n = Uint16.zero)
        ~h:Uint16.(x' land of_int 0x07FF + y' land of_int 0x07FF > of_int 0x07FF)
        ~n:false
        ~c:Uint16.(x' > of_int 0xFFFF - y') ();
      (x <-- n) t;
      Next
    | ADC (x, y) ->
      let c = if Registers.(read_flag t.registers Carry) then Uint8.one else Uint8.zero in
      let x', y' = read x t, read y t in
      let n = Uint8.(x' + y' + c) in
      set_flags
        ~z:(n = Uint8.zero)
        ~h:Uint8.(x' land of_int 0xF + y' land of_int 0xF + c > of_int 0xF)
        ~n:false
        ~c:((Uint8.to_int x' + Uint8.to_int y' + Uint8.to_int c) > 0xFF) ();
      (x <-- n) t;
      Next
    | SUB (x, y) ->
      let x', y' = read x t, read y t in
      let n = Uint8.(x' - y') in
      set_flags
        ~z:(n = Uint8.zero)
        ~h:Uint8.(x' land of_int 0xF < y' land of_int 0xF)
        ~n:true
        ~c:((Uint8.to_int x') < Uint8.to_int y') ();
      (x <-- n) t;
      Next
    | SBC (x, y) ->
      let c = if Registers.(read_flag t.registers Carry) then Uint8.one else Uint8.zero in
      let x', y' = read x t, read y t in
      let n = Uint8.(x' - (y' + c)) in
      set_flags
        ~z:(n = Uint8.zero)
        ~h:Uint8.(x' land of_int 0xF < y' land of_int 0xF + c)
        ~n:true
        ~c:((Uint8.to_int x') < Uint8.to_int y' + Uint8.to_int c) ();
      (x <-- n) t;
      Next
    | AND (x, y) ->
      let n = Uint8.(read x t lor read y t) in
      set_flags ~z:(n = Uint8.zero) ~h:false ~n:false ~c:false ();
      (x <-- n) t; Next
    | OR (x, y) ->
      let n = Uint8.(read x t lor read y t) in
      set_flags ~z:(n = Uint8.zero) ~h:false ~n:false ~c:false ();
      (x <-- n) t; Next
    | XOR (x, y) ->
      let n = Uint8.(read x t lxor read y t) in
      set_flags ~z:(n = Uint8.zero) ~h:false ~n:false ~c:false ();
      (x <-- n) t; Next
    | CP (x, y) ->
      let x', y' = read x t, read y t in
      let n = Uint8.(x' - y') in
      set_flags
        ~z:(n = Uint8.zero)
        ~h:Uint8.(x' land of_int 0xF < y' land of_int 0xF)
        ~n:true
        ~c:((Uint8.to_int x') < Uint8.to_int y') ();
      Next
    | INC x ->
      let x' = (read x t) in
      let n = Uint8.(succ x') in
      set_flags ~z:(n = Uint8.zero) ~h:((Uint8.to_int x'+ 1) > 0x0F) ~n:false ();
      (x <-- n) t;
      Next
    | INC16 x ->
      let open SBM in
      (x <-- Uint16.(succ @@ read x t)) t;
      Next
    | DEC x ->
      let x' = (read x t) in
      let n = Uint8.(pred x') in
      set_flags ~z:(n = Uint8.zero) ~h:Uint8.(x' land of_int 0x0F = of_int 0x0) ~n:true ();
      (x <-- n) t;
      Next
    | DEC16 x ->
      let open SBM in
      (x <-- Uint16.(pred @@ read x t)) t;
      Next
    | SWAP x ->
      let x' = read x t in
      (x <-- Uint8.((x' lsl 4) lor (x' lsr 4))) t;
      Next
    | DAA -> assert false;
    | CPL ->
      set_flags ~n:true ~h:true ();
      Registers.read_r t.registers A
      |> (fun n -> Uint8.(n lxor max_int))
      |> Registers.write_r t.registers A;
      Next
    | CCF ->
      let c = Registers.read_flag t.registers Carry in
      set_flags ~n:false ~h:false ~c:(not c) ();
      Next
    | SCF ->
      set_flags ~n:false ~h:false ~c:true ();
      Next
    | NOP -> Next
    | HALT -> assert false;
    | STOP -> assert false;
    | DI -> assert false;
    | EI -> assert false;
    | RLCA ->
      assert false;
    | RLA          -> assert false;
    | RRCA         -> assert false;
    | RRA          -> assert false;
    | RLC x        -> ignore(x); assert false;
    | RL x         -> ignore(x); assert false;
    | RRC x        -> ignore(x); assert false;
    | RR x         -> ignore(x); assert false;
    | SLA x        -> ignore(x); assert false;
    | SRA x        -> ignore(x); assert false;
    | SRL x        -> ignore(x); assert false;
    | BIT (n, x)   -> ignore(x, n); assert false;
    | SET (n, x)   -> ignore(x, n); assert false;
    | RES (n, x)   -> ignore(x, n); assert false;
    | PUSH rr      -> ignore(rr); assert false;
    | POP rr       -> ignore(rr); assert false;
    | JR (c, x) ->
      if check_condition t c then
        Jump Uint16.(t.pc + of_uint8 x)
      else
        Next
    | CALL (c, x) ->
      if check_condition t c then
        Jump x
      else
        Next
    | JP (c, x) ->
      if check_condition t c then
        Jump SBM.(read x t)
      else
        Next
    | RST x -> ignore(x); assert false;
    | RET c -> ignore(c); assert false;
    | RETI  -> assert false
  in
  match next_pc with
  | Next -> t.pc <- Uint16.(t.pc + inst_len)
  | Jump addr -> t.pc <- addr

let tick t  =
  let (inst_len, inst) = Instruction.fetch_and_decode t.mmu ~pc:t.pc in
  execute t inst_len inst

module For_tests = struct
  let execute = execute
  let create ~mmu ~registers ~sp ~pc = {registers; mmu; sp; pc}
end
