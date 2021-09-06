open Uints

module Make (Mmu : Word_addressable.S) = struct

  type t = {
    registers : Registers.t;
    mutable pc : uint16;
    mutable sp : uint16;
    mmu : Mmu.t;
    mutable halted : bool;
    mutable ime : bool; (* interrupt master enable *)
    mutable until_enable_ime : count_down;
    mutable until_disable_ime : count_down;
    mutable prev_inst : Instruction.t (* for debugging purpose *)
  }
  and count_down =
    | One
    | Zero
    | None

  let show t =
    Printf.sprintf "%s SP:%s PC:%s"
      (Registers.show t.registers) (t.sp |> Uint16.show) (t.pc |> Uint16.show)

  let pp fmt t = Format.fprintf fmt "%s" (show t)

  let create mmu = {
    registers = Registers.create ();
    pc = Uint16.zero;
    sp = Uint16.zero;
    mmu;
    halted = false;
    ime = true;
    until_enable_ime = None;
    until_disable_ime = None;
    prev_inst = NOP;
  }


  type next_pc = Next | Jump of uint16

  let execute (t : t) (cycles : int * int)  (inst : Instruction.t) : int =
    let read : type a. a Instruction.arg -> a = fun arg ->
      match arg with
      | Immediate8 n -> n
      | Immediate16 n -> n
      | Direct8 addr -> Mmu.read_byte t.mmu addr
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
      | HL_inc ->
        let addr = Registers.read_rr t.registers HL in
        Registers.write_rr t.registers HL Uint16.(succ addr);
        Mmu.read_byte t.mmu addr
      | HL_dec ->
        let addr = Registers.read_rr t.registers HL in
        Registers.write_rr t.registers HL Uint16.(pred addr);
        Mmu.read_byte t.mmu addr
      | Direct16 addr -> Mmu.read_word t.mmu addr
      | RR rr -> Registers.read_rr t.registers rr
      | SP -> t.sp
      | SP_offset n -> Uint16.to_int t.sp + Int8.to_int n |> Uint16.of_int
    in
    let write : type a. a Instruction.arg -> a -> unit = fun x y ->
      match x with
      | R r -> Registers.write_r t.registers r y
      | RR rr -> Registers.write_rr t.registers rr y
      | FF00_offset n ->
        let addr = Uint16.(of_int 0xFF00 + of_uint8 n) in
        Mmu.write_byte t.mmu ~addr ~data:y
      | RR_indirect rr ->
        let addr = Registers.read_rr t.registers rr in
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
      | Direct8 addr -> Mmu.write_byte t.mmu ~addr ~data:y
      | Direct16 addr -> Mmu.write_word t.mmu ~addr ~data:y
      | SP -> t.sp <- y
      | SP_offset _
      | Immediate16 _
      | Immediate8 _ -> failwith @@ Printf.sprintf "Invalid arugment"
    in
    let (<--) x y = write x y in
    let check_condition t : Instruction.condition -> bool = function
      | None -> true
      | Z    -> Registers.read_flag t.registers Zero
      | NZ   -> not (Registers.read_flag t.registers Zero)
      | C    -> Registers.read_flag t.registers Carry
      | NC   -> not (Registers.read_flag t.registers Carry)
    in
    let set_flags = Registers.set_flags t.registers in
    let next_pc = match inst with
      | LD8 (x, y) ->
        x <-- read y;
        Next
      | LD16 (x, y) ->
        x <-- read y;
        Next
      | ADD8 (x, y) ->
        let x', y' = read x, read y in
        let n = Uint8.(x' + y') in
        set_flags
          ~z:(n = Uint8.zero)
          ~h:Uint8.(x' land of_int 0xF + y' land of_int 0xF > of_int 0xF)
          ~n:false
          ~c:Uint8.(x' > of_int 0xFF - y') ();
        x <-- n;
        Next
      | ADD16 (x, y) ->
        let x', y' = read x, read y in
        let n = Uint16.(x' + y') in
        set_flags
          ~h:Uint16.(x' land of_int 0x0FFF + y' land of_int 0x0FFF > of_int 0x0FFF)
          ~n:false
          ~c:Uint16.(x' > of_int 0xFFFF - y') ();
        x <-- n;
        Next
      | ADDSP y ->
        (* For "ADD SP, n" the flags are set as if the instruction was a 8 bit add.
         * This is because we only add the lower 8 bits *)
        let x', y' = read SP, Uint16.of_uint8 y in
        let n = Uint16.(x' + y') in
        set_flags
          ~z:false
          ~h:Uint16.(x' land of_int 0xF + y' land of_int 0xF > of_int 0xF)
          ~n:false
          ~c:Uint16.(x' > of_int 0xFF - y') ();
        SP <-- n;
        Next
      | ADC (x, y) ->
        let c = if Registers.(read_flag t.registers Carry) then Uint8.one else Uint8.zero in
        let x', y' = read x, read y in
        let n = Uint8.(x' + y' + c) in
        set_flags
          ~z:(n = Uint8.zero)
          ~h:Uint8.(x' land of_int 0xF + y' land of_int 0xF + c > of_int 0xF)
          ~n:false
          ~c:((Uint8.to_int x' + Uint8.to_int y' + Uint8.to_int c) > 0xFF) ();
        x <-- n;
        Next
      | SUB (x, y) ->
        let x', y' = read x, read y in
        let n = Uint8.(x' - y') in
        set_flags
          ~z:(n = Uint8.zero)
          ~h:Uint8.(x' land of_int 0xF < y' land of_int 0xF)
          ~n:true
          ~c:((Uint8.to_int x') < Uint8.to_int y') ();
        x <-- n;
        Next
      | SBC (x, y) ->
        let c = if Registers.(read_flag t.registers Carry) then Uint8.one else Uint8.zero in
        let x', y' = read x, read y in
        let n = Uint8.(x' - (y' + c)) in
        set_flags
          ~z:(n = Uint8.zero)
          ~h:Uint8.(x' land of_int 0xF < y' land of_int 0xF + c)
          ~n:true
          ~c:((Uint8.to_int x') < Uint8.to_int y' + Uint8.to_int c) ();
        x <-- n;
        Next
      | AND (x, y) ->
        let n = Uint8.(read x land read y) in
        set_flags ~z:(n = Uint8.zero) ~h:true ~n:false ~c:false ();
        x <-- n;
        Next
      | OR (x, y) ->
        let n = Uint8.(read x lor read y) in
        set_flags ~z:(n = Uint8.zero) ~h:false ~n:false ~c:false ();
        x <-- n;
        Next
      | XOR (x, y) ->
        let n = Uint8.(read x lxor read y) in
        set_flags ~z:(n = Uint8.zero) ~h:false ~n:false ~c:false ();
        x <-- n;
        Next
      | CP (x, y) ->
        let x', y' = read x, read y in
        let n = Uint8.(x' - y') in
        set_flags
          ~z:(n = Uint8.zero)
          ~h:Uint8.(x' land of_int 0xF < y' land of_int 0xF)
          ~n:true
          ~c:((Uint8.to_int x') < Uint8.to_int y') ();
        Next
      | INC x ->
        let x' = (read x) in
        let n = Uint8.(succ x') in
        set_flags
          ~z:(n = Uint8.zero)
          ~h:Uint8.(x' land of_int 0x0F = of_int 0x0F)
          ~n:false ();
        x <-- n;
        Next
      | INC16 x ->
        x <-- Uint16.(succ @@ read x);
        Next
      | DEC x ->
        let x' = (read x) in
        let n = Uint8.(pred x') in
        set_flags
          ~z:(n = Uint8.zero)
          ~h:Uint8.(x' land of_int 0x0F = of_int 0x0)
          ~n:true ();
        x <-- n;
        Next
      | DEC16 x ->
        x <-- Uint16.(pred @@ read x);
        Next
      | SWAP x ->
        let x' = read x in
        x <-- Uint8.((x' lsl 4) lor (x' lsr 4));
        Next
      | DAA ->
        let n_flag = Registers.read_flag t.registers Subtraction in
        let c_flag = Registers.read_flag t.registers Carry in
        let h_flag = Registers.read_flag t.registers Half_carry in
        let a = ref (Registers.read_r t.registers A) in
        let open Uint8 in
        begin match n_flag with
          | false ->
            if c_flag || !a > of_int 0x9F then
              a := !a + of_int 0x60;
            if h_flag || (!a land of_int 0x0F) > of_int 0x09 then
              a := !a + of_int 0x06
          | true ->
            if c_flag then
              a := !a - of_int 0x60;
            if h_flag then
              a := !a - of_int 0x06;
        end;
        set_flags ~h:false ~z:(!a = zero) ~c:(!a > of_int 0xFF) ();
        Registers.write_r t.registers A !a;
        Next
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
        let new_c = Uint8.(a land of_int 0x1 <> zero) in
        set_flags ~n:false ~h:false ~z:false ~c:new_c ();
        Next
      | RLC x ->
        let x' = read x in
        let c = Uint8.(x' land of_int 0x80 <> zero) in
        let n = Uint8.((x' lsl 1) lor if c then one else zero) in
        x <-- n;
        set_flags ~n:false ~h:false ~z:Uint8.(n = zero) ~c ();
        Next
      | RL x ->
        let x' = read x in
        let old_c = Registers.read_flag t.registers Carry in
        let n = Uint8.((x' lsl 1) lor if old_c then one else zero) in
        x <-- n;
        let new_c = Uint8.(x' land of_int 0x80 <> zero) in
        set_flags ~n:false ~h:false ~z:Uint8.(n = zero) ~c:new_c ();
        Next
      | RRC x ->
        let x' = read x in
        let c = Uint8.(x' land of_int 1 <> zero) in
        let n = Uint8.((x' lsr 1) lor if c then of_int 0x80 else zero) in
        x <-- n;
        set_flags ~n:false ~h:false ~z:Uint8.(n = zero) ~c ();
        Next
      | RR x ->
        let x' = read x in
        let old_c = Registers.read_flag t.registers Carry in
        let n = Uint8.((x' lsr 1) lor if old_c then of_int 0x80 else zero) in
        x <-- n;
        set_flags ~n:false ~h:false ~z:Uint8.(n = zero) ~c:Uint8.(x' land of_int 0x1 <> zero) ();
        Next
      | SLA x ->
        let x' = read x in
        let n = Uint8.(x' lsl 1) in
        x <-- n;
        set_flags ~n:false ~h:false ~z:Uint8.(n = zero) ~c:Uint8.(x' land of_int 0x80 <> zero) ();
        Next
      | SRA x ->
        let x' = read x in
        let n = Uint8.((x' lsr 1) lor (x' land of_int 0x80)) in
        x <-- n;
        set_flags ~n:false ~h:false ~z:Uint8.(n = zero) ~c:Uint8.(x' land of_int 0x1 <> zero) ();
        Next
      | SRL x ->
        let x' = read x in
        let n = Uint8.(x' lsr 1) in
        x <-- n;
        set_flags ~n:false ~h:false ~z:Uint8.(n = zero) ~c:Uint8.(x' land of_int 0x1 <> zero) ();
        Next
      | BIT (n, x) ->
        let b = Uint8.(read x land (one lsl to_int n) = zero) in
        set_flags ~n:false ~h:true ~z:b ();
        Next
      | SET (n, x) ->
        x <-- Uint8.(read x lor (one lsl to_int n));
        Next
      | RES (n, x) ->
        let mask = Uint8.((one lsl to_int n) lxor of_int 0b11111111) in
        x <-- Uint8.(read x land mask);
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
          Jump (read x)
        else
          Next
      | JR (c, x) ->
        if check_condition t c then
          let addr = Uint16.to_int t.pc + Int8.to_int x |> Uint16.of_int in
          Jump addr
        else
          Next
      | CALL (c, x) ->
        if check_condition t c then begin
          t.sp <- Uint16.(t.sp - of_int 2);
          Mmu.write_word t.mmu ~addr:t.sp ~data:t.pc;
          Jump x
        end else
          Next
      | RST x ->
        t.sp <- Uint16.(t.sp - of_int 2);
        Mmu.write_word t.mmu ~addr:t.sp ~data:t.pc;
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
    t.prev_inst <- inst;
    match next_pc, cycles with
    | Next, (not_branched_mcycle, _) ->
      not_branched_mcycle
    | Jump addr, (_, branched_mcycle) ->
      t.pc <- addr;
      branched_mcycle

  let update_ime t =
    begin match t.until_enable_ime with
      | One  -> t.until_enable_ime <- Zero
      | Zero -> t.until_enable_ime <- None; t.ime <- true
      | None -> ()
    end;
    match t.until_disable_ime with
    | One  -> t.until_disable_ime <- Zero
    | Zero -> t.until_disable_ime <- None; t.ime <- true
    | None -> ()

  module Fetch_and_decode = Fetch_and_decode.Make(Mmu)

  let tick t  =
    update_ime t;
    let (len, cycles, inst) = Fetch_and_decode.f t.mmu ~pc:t.pc in
    t.pc <- Uint16.(t.pc + len);
    execute t cycles inst

  module For_tests = struct

    let execute = execute

    let create ~mmu ~registers ~sp ~pc ~halted ~ime = {registers; mmu; sp; pc; halted; ime; until_enable_ime = None; until_disable_ime = None; prev_inst = NOP}

    let prev_inst t = t.prev_inst

    let current_pc t = t.pc

  end

end
