open Uints

module Make (Mmu : Word_addressable_intf.S) = struct

  module Fetch_and_decode = Fetch_and_decode.Make(Mmu)

  type t = {
    registers : Registers.t;
    mutable pc : uint16;
    mutable sp : uint16;
    mmu : Mmu.t;                  [@opaque]
    mutable halted : bool;
    mutable ime : bool;           (* interrupt master enable *)
    mutable until_enable_ime : count_down;
    mutable until_disable_ime : count_down;
  }
  [@@deriving show]

  and count_down =
    | One   [@printer fun fmt _ -> fprintf fmt "1"]
    | Zero  [@printer fun fmt _ -> fprintf fmt "0"]
    | None  [@printer fun fmt _ -> fprintf fmt "_"]
  [@@deriving show]

  let create mmu = {
    registers = Registers.create ();
    pc = Uint16.zero;
    sp = Uint16.zero;
    mmu;
    halted = false;
    ime = true;
    until_enable_ime = None;
    until_disable_ime = None;
  }

  (** Functions for reading/writing arguments of 8 bit load/arithmic operations
   **  such as "LD B, 0xAB" and "ADD B, 0xAB" *)
  module Eight_bit_mode = struct
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

    let write (x : Instruction.arg) (y : uint8) (t : t) : unit =
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
      | HL_inc ->
        let addr = Registers.read_rr t.registers HL in
        Mmu.write_byte t.mmu ~addr ~data:y;
        Registers.write_rr t.registers HL Uint16.(succ addr)
      | HL_dec ->
        let addr = Registers.read_rr t.registers HL in
        Mmu.write_byte t.mmu ~addr ~data:y;
        Registers.write_rr t.registers HL Uint16.(pred addr)
      | Direct addr -> Mmu.write_byte t.mmu ~addr ~data:y
      | Immediate _ -> failwith @@ Printf.sprintf "Invalid arugment: %s" (Instruction.show_arg x)

    let (<--) x y t = write x y t
  end

  (** Functions for reading/writing arguments of 16 bit load/arithmic operations
   **  such as "LD BC, 0xABCD" and "ADD BC, 0xABCD" *)
  module Sixteen_bit_mode = struct
    let read (x : Instruction.arg16) (t : t) : uint16 =
      match x with
      | Immediate n -> n
      | Immediate8 n -> n |> Uint16.of_uint8
      | Direct addr -> Mmu.read_word t.mmu addr
      | RR rr -> Registers.read_rr t.registers rr
      | SP -> t.sp
      | SP_offset n -> Uint16.(t.sp + of_uint8 n)

    let write (x : Instruction.arg16) (y : uint16) (t : t) : unit =
      match x with
      | Direct addr -> Mmu.write_word t.mmu ~addr ~data:y
      | RR rr -> Registers.write_rr t.registers rr y
      | SP -> t.sp <- y
      | Immediate _
      | Immediate8 _
      | SP_offset _ -> failwith @@ Printf.sprintf "Invalid arugment: %s" (Instruction.show_arg16 x)

    let (<--) x y t = write x y t
  end

  type next_pc = Next | Jump of uint16

  let execute (t : t) (inst_len : uint16) (cycles : int * int)  (inst : Instruction.t) : int =
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
      | ADD16 (SP, y) ->
        (* For "ADD SP, n" the flags are set as if the instruction was a 8 bit add.
         * This is because we only add the lower 8 bits *)
        let open SBM in
        let x', y' = read SP t, read y t in
        let n = Uint16.(x' + y') in
        set_flags
          ~z:false
          ~h:Uint16.(x' land of_int 0xF + y' land of_int 0xF > of_int 0xF)
          ~n:false
          ~c:Uint16.(x' > of_int 0xFF - y') ();
        (SP <-- n) t;
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
      | HALT ->
        t.halted <- true;
        Next
      | STOP -> assert false;
      | DI ->
        t.until_disable_ime <- One;
        Next
      | EI ->
        t.until_enable_ime <- One;
        Next
      | RLCA ->
        let a = Registers.read_r t.registers A in
        let c = Uint8.(a land of_int 0x80 <> zero) in
        let n = Uint8.((a lsl 1) lor if c then one else zero) in
        Registers.write_r t.registers A n;
        set_flags ~n:false ~h:false ~z:false ~c ();
        Next
      | RLA ->
        let a = Registers.read_r t.registers A in
        let old_c = Registers.read_flag t.registers Carry in
        let n = Uint8.((a lsl 1) lor if old_c then one else zero) in
        Registers.write_r t.registers A n;
        let new_c = Uint8.(a land of_int 0x80 <> zero) in
        set_flags ~n:false ~h:false ~z:false ~c:new_c ();
        Next
      | RRCA ->
        let a = Registers.read_r t.registers A in
        let c = Uint8.(a land of_int 1 <> zero) in
        let n = Uint8.((a lsr 1) lor if c then of_int 0x80 else zero) in
        Registers.write_r t.registers A n;
        set_flags ~n:false ~h:false ~z:false ~c:c ();
        Next
      | RRA ->
        let a = Registers.read_r t.registers A in
        let old_c = Registers.read_flag t.registers Carry in
        let n = Uint8.((a lsr 1) lor if old_c then of_int 0x80 else zero) in
        Registers.write_r t.registers A n;
        let new_c = Uint8.(a land of_int 0x80 <> zero) in
        set_flags ~n:false ~h:false ~z:false ~c:new_c ();
        Next
      | RLC x ->
        let x' = read x t in
        let c = Uint8.(x' land of_int 0x80 <> zero) in
        let n = Uint8.((x' lsl 1) lor if c then one else zero) in
        (x <-- n) t;
        set_flags ~n:false ~h:false ~z:Uint8.(n = zero) ~c ();
        Next
      | RL x ->
        let x' = read x t in
        let old_c = Registers.read_flag t.registers Carry in
        let n = Uint8.((x' lsl 1) lor if old_c then one else zero) in
        (x <-- n) t;
        let new_c = Uint8.(x' land of_int 0x80 <> zero) in
        set_flags ~n:false ~h:false ~z:Uint8.(n = zero) ~c:new_c ();
        Next
      | RRC x ->
        let x' = read x t in
        let c = Uint8.(x' land of_int 1 <> zero) in
        let n = Uint8.((x' lsr 1) lor if c then of_int 0x80 else zero) in
        (x <-- n) t;
        set_flags ~n:false ~h:false ~z:Uint8.(n = zero) ~c ();
        Next
      | RR x ->
        let x' = read x t in
        let old_c = Registers.read_flag t.registers Carry in
        let n = Uint8.((x' lsr 1) lor if old_c then of_int 0x80 else zero) in
        (x <-- n) t;
        set_flags ~n:false ~h:false ~z:Uint8.(n = zero) ~c:Uint8.(x' land of_int 0x80 <> zero) ();
        Next
      | SLA x ->
        let x' = read x t in
        let n = Uint8.(x' lsl 1) in
        (x <-- n) t;
        set_flags ~n:false ~h:false ~z:Uint8.(n = zero) ~c:Uint8.(x' land of_int 0x80 <> zero) ();
        Next
      | SRA x ->
        let x' = read x t in
        let n = Uint8.((x' lsr 1) lor (x' land of_int 0x80)) in
        (x <-- n) t;
        set_flags ~n:false ~h:false ~z:Uint8.(n = zero) ~c:Uint8.(x' land of_int 0x1 <> zero) ();
        Next
      | SRL x ->
        let x' = read x t in
        let n = Uint8.(x' lsr 1) in
        (x <-- n) t;
        set_flags ~n:false ~h:false ~z:Uint8.(n = zero) ~c:Uint8.(x' land of_int 0x1 <> zero) ();
        Next
      | BIT (n, x) ->
        let b = Uint8.(read x t land (one lsl to_int n) = zero) in
        set_flags ~n:false ~h:true ~z:b ();
        Next
      | SET (n, x) ->
        (x <-- Uint8.(read x t lor (one lsl to_int n))) t;
        Next
      | RES (n, x) ->
        let mask = Uint8.((one lsl to_int n) lxor of_int 0b11111111) in
        (x <-- Uint8.(read x t land mask)) t;
        Next
      | PUSH rr ->
        t.sp <- Uint16.(t.sp - of_int 2);
        Mmu.write_word t.mmu ~addr:t.sp ~data:(Registers.read_rr t.registers rr);
        Next
      | POP rr ->
        Registers.write_rr t.registers rr (Mmu.read_word t.mmu t.sp);
        t.sp <- Uint16.(t.sp + of_int 2);
        Next
      | JP (c, x) ->
        if check_condition t c then
          Jump SBM.(read x t)
        else
          Next
      | JR (c, x) ->
        if check_condition t c then
          Jump Uint16.(t.pc + of_uint8 x)
        else
          Next
      | CALL (c, x) ->
        if check_condition t c then begin
          t.sp <- Uint16.(t.sp - of_int 2);
          Mmu.write_word t.mmu ~addr:t.sp ~data:Uint16.(t.pc + inst_len);
          Jump x
        end else
          Next
      | RST x ->
        t.sp <- Uint16.(t.sp - of_int 2);
        Mmu.write_word t.mmu ~addr:t.sp ~data:Uint16.(t.pc + inst_len);
        Jump x
      | RET c ->
        if check_condition t c then begin
          let addr = Mmu.read_word t.mmu t.sp in
          t.sp <- Uint16.(t.sp + of_int 2);
          Jump addr
        end else
          Next
      | RETI  ->
        let addr = Mmu.read_word t.mmu t.sp in
        t.sp <- Uint16.(t.sp + of_int 2);
        t.ime <- true;
        Jump addr
    in
    match next_pc, cycles with
    | Next, (no_branch_mcycle, _) ->
      t.pc <- Uint16.(t.pc + inst_len);
      no_branch_mcycle
    | Jump addr, (_, branch_mcycle) ->
      t.pc <- addr;
      branch_mcycle

  let update_ime t =
    begin match t.until_enable_ime with
      | One -> t.until_enable_ime <- Zero
      | Zero -> t.until_enable_ime <- None; t.ime <- true
      | None -> ()
    end;
    match t.until_disable_ime with
    | One -> t.until_disable_ime <- Zero
    | Zero -> t.until_disable_ime <- None; t.ime <- true
    | None -> ()

  let tick t  =
    update_ime t;
    let (len, cycles, inst) = Fetch_and_decode.f t.mmu ~pc:t.pc in
    execute t len cycles inst

  module For_tests = struct
    let execute = execute
    let create ~mmu ~registers ~sp ~pc ~halted ~ime = {registers; mmu; sp; pc; halted; ime; until_enable_ime = None; until_disable_ime = None}
  end

end
