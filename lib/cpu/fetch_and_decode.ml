open Uints
open Instruction

module Make (Bus : Word_addressable_intf.S) = struct

  type mcycles = {
    not_branched : int;
    branched : int;
  }

  type inst_info = {
    len : uint16;
    mcycles : mcycles;
    inst : Instruction.t;
  }

  module RST_offset = struct
    let x00 = 0x00 |> Uint16.of_int
    let x08 = 0x08 |> Uint16.of_int
    let x10 = 0x10 |> Uint16.of_int
    let x18 = 0x18 |> Uint16.of_int
    let x20 = 0x20 |> Uint16.of_int
    let x28 = 0x28 |> Uint16.of_int
    let x30 = 0x30 |> Uint16.of_int
    let x38 = 0x38 |> Uint16.of_int
  end

  module Instruction_length = struct
    let l1 = 1 |> Uint16.of_int
    let l2 = 2 |> Uint16.of_int
    let l3 = 3 |> Uint16.of_int
  end

  let f bus ~pc : inst_info =
    let open Instruction_length in
    let addr_after_pc = Uint16.(succ pc) in
    let next_byte () = Bus.read_byte bus addr_after_pc in
    let next_word () = Bus.read_word bus addr_after_pc in
    let op = Bus.read_byte bus pc |> Uint8.to_int in
    match op with
    | 0x00 -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = NOP }
    | 0x01 -> { len = l3; mcycles = { not_branched = 3; branched = 3}; inst = LD16 (RR BC, Immediate16 (next_word ())) }
    | 0x02 -> { len = l1; mcycles = { not_branched = 2; branched = 2}; inst = LD8 (RR_indirect BC, R A) }
    | 0x03 -> { len = l1; mcycles = { not_branched = 2; branched = 2}; inst = INC16 (RR BC) }
    | 0x04 -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = INC (R B) }
    | 0x05 -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = DEC (R B) }
    | 0x06 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = LD8 (R B, Immediate8 (next_byte ())) }
    | 0x07 -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = RLCA }
    | 0x08 -> { len = l3; mcycles = { not_branched = 5; branched = 5}; inst = LD16 (Direct16 (next_word ()), SP) }
    | 0x09 -> { len = l1; mcycles = { not_branched = 2; branched = 2}; inst = ADD16 (RR HL, RR BC) }
    | 0x0A -> { len = l1; mcycles = { not_branched = 2; branched = 2}; inst = LD8 (R A, RR_indirect BC) }
    | 0x0B -> { len = l1; mcycles = { not_branched = 2; branched = 2}; inst = DEC16 (RR BC) }
    | 0x0C -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = INC (R C) }
    | 0x0D -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = DEC (R C) }
    | 0x0E -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = LD8 (R C, Immediate8 (next_byte ())) }
    | 0x0F -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = RRCA }
    | 0x10 -> ignore(next_byte ()); { len = l2; mcycles = { not_branched = 1; branched = 1}; inst = STOP }
    | 0x11 -> { len = l3; mcycles = { not_branched = 3; branched = 3}; inst = LD16 (RR DE, Immediate16 (next_word ())) }
    | 0x12 -> { len = l1; mcycles = { not_branched = 2; branched = 2}; inst = LD8 (RR_indirect DE, R A) }
    | 0x13 -> { len = l1; mcycles = { not_branched = 2; branched = 2}; inst = INC16 (RR DE) }
    | 0x14 -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = INC (R D) }
    | 0x15 -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = DEC (R D) }
    | 0x16 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = LD8 (R D, Immediate8 (next_byte ())) }
    | 0x17 -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = RLA }
    | 0x18 -> { len = l2; mcycles = { not_branched = 3; branched = 3}; inst = JR (None, (Int8.of_byte @@ next_byte ())) }
    | 0x19 -> { len = l1; mcycles = { not_branched = 2; branched = 2}; inst = ADD16 (RR HL, RR DE) }
    | 0x1A -> { len = l1; mcycles = { not_branched = 2; branched = 2}; inst = LD8 (R A, RR_indirect DE) }
    | 0x1B -> { len = l1; mcycles = { not_branched = 2; branched = 2}; inst = DEC16 (RR DE) }
    | 0x1C -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = INC (R E) }
    | 0x1D -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = DEC (R E) }
    | 0x1E -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = LD8 (R E, Immediate8 (next_byte ())) }
    | 0x1F -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = RRA }
    | 0x20 -> { len = l2; mcycles = { not_branched = 2; branched = 3}; inst = JR (NZ, Int8.of_byte @@ next_byte ()) }
    | 0x21 -> { len = l3; mcycles = { not_branched = 3; branched = 3}; inst = LD16 (RR HL, Immediate16 (next_word ())) }
    | 0x22 -> { len = l1; mcycles = { not_branched = 2; branched = 2}; inst = LD8 (HL_inc, R A) }
    | 0x23 -> { len = l1; mcycles = { not_branched = 2; branched = 2}; inst = INC16 (RR HL) }
    | 0x24 -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = INC (R H) }
    | 0x25 -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = DEC (R H) }
    | 0x26 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = LD8 (R H, Immediate8 (next_byte ())) }
    | 0x27 -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = DAA }
    | 0x28 -> { len = l2; mcycles = { not_branched = 2; branched = 3}; inst = JR (Z, Int8.of_byte @@ next_byte ()) }
    | 0x29 -> { len = l1; mcycles = { not_branched = 2; branched = 2}; inst = ADD16 (RR HL,RR HL) }
    | 0x2A -> { len = l1; mcycles = { not_branched = 2; branched = 2}; inst = LD8 (R A, HL_inc) }
    | 0x2B -> { len = l1; mcycles = { not_branched = 2; branched = 2}; inst = DEC16 (RR HL) }
    | 0x2C -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = INC (R L) }
    | 0x2D -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = DEC (R L) }
    | 0x2E -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = LD8 (R L, Immediate8 (next_byte ())) }
    | 0x2F -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = CPL }
    | 0x30 -> { len = l2; mcycles = { not_branched = 2; branched = 3}; inst = JR (NC, Int8.of_byte @@ next_byte ()) }
    | 0x31 -> { len = l3; mcycles = { not_branched = 3; branched = 3}; inst = LD16 (SP, Immediate16 (next_word ())) }
    | 0x32 -> { len = l1; mcycles = { not_branched = 2; branched = 2}; inst = LD8 (HL_dec, R A) }
    | 0x33 -> { len = l1; mcycles = { not_branched = 2; branched = 2}; inst = INC16 SP }
    | 0x34 -> { len = l1; mcycles = { not_branched = 3; branched = 3}; inst = INC (RR_indirect HL) }
    | 0x35 -> { len = l1; mcycles = { not_branched = 3; branched = 3}; inst = DEC (RR_indirect HL) }
    | 0x36 -> { len = l2; mcycles = { not_branched = 3; branched = 3}; inst = LD8 (RR_indirect HL, Immediate8 (next_byte ())) }
    | 0x37 -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = SCF }
    | 0x38 -> { len = l2; mcycles = { not_branched = 2; branched = 3}; inst = JR (C, Int8.of_byte @@ next_byte ()) }
    | 0x39 -> { len = l1; mcycles = { not_branched = 2; branched = 2}; inst = ADD16 (RR HL, SP) }
    | 0x3A -> { len = l1; mcycles = { not_branched = 2; branched = 2}; inst = LD8 (R A, HL_dec) }
    | 0x3B -> { len = l1; mcycles = { not_branched = 2; branched = 2}; inst = DEC16 SP }
    | 0x3C -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = INC (R A) }
    | 0x3D -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = DEC (R A) }
    | 0x3E -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = LD8 (R A, Immediate8 (next_byte ())) }
    | 0x3F -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = CCF }
    | 0x40 -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = LD8 (R B, R B) }
    | 0x41 -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = LD8 (R B, R C) }
    | 0x42 -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = LD8 (R B, R D) }
    | 0x43 -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = LD8 (R B, R E) }
    | 0x44 -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = LD8 (R B, R H) }
    | 0x45 -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = LD8 (R B, R L) }
    | 0x46 -> { len = l1; mcycles = { not_branched = 2; branched = 2}; inst = LD8 (R B, RR_indirect HL) }
    | 0x47 -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = LD8 (R B, R A) }
    | 0x48 -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = LD8 (R C, R B) }
    | 0x49 -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = LD8 (R C, R C) }
    | 0x4A -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = LD8 (R C, R D) }
    | 0x4B -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = LD8 (R C, R E) }
    | 0x4C -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = LD8 (R C, R H) }
    | 0x4D -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = LD8 (R C, R L) }
    | 0x4E -> { len = l1; mcycles = { not_branched = 2; branched = 2}; inst = LD8 (R C, RR_indirect HL) }
    | 0x4F -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = LD8 (R C, R A) }
    | 0x50 -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = LD8 (R D, R B) }
    | 0x51 -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = LD8 (R D, R C) }
    | 0x52 -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = LD8 (R D, R D) }
    | 0x53 -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = LD8 (R D, R E) }
    | 0x54 -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = LD8 (R D, R H) }
    | 0x55 -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = LD8 (R D, R L) }
    | 0x56 -> { len = l1; mcycles = { not_branched = 2; branched = 2}; inst = LD8 (R D, RR_indirect HL) }
    | 0x57 -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = LD8 (R D, R A) }
    | 0x58 -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = LD8 (R E, R B) }
    | 0x59 -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = LD8 (R E, R C) }
    | 0x5A -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = LD8 (R E, R D) }
    | 0x5B -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = LD8 (R E, R E) }
    | 0x5C -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = LD8 (R E, R H) }
    | 0x5D -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = LD8 (R E, R L) }
    | 0x5E -> { len = l1; mcycles = { not_branched = 2; branched = 2}; inst = LD8 (R E, RR_indirect HL) }
    | 0x5F -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = LD8 (R E, R A) }
    | 0x60 -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = LD8 (R H, R B) }
    | 0x61 -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = LD8 (R H, R C) }
    | 0x62 -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = LD8 (R H, R D) }
    | 0x63 -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = LD8 (R H, R E) }
    | 0x64 -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = LD8 (R H, R H) }
    | 0x65 -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = LD8 (R H, R L) }
    | 0x66 -> { len = l1; mcycles = { not_branched = 2; branched = 2}; inst = LD8 (R H, RR_indirect HL) }
    | 0x67 -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = LD8 (R H, R A) }
    | 0x68 -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = LD8 (R L, R B) }
    | 0x69 -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = LD8 (R L, R C) }
    | 0x6A -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = LD8 (R L, R D) }
    | 0x6B -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = LD8 (R L, R E) }
    | 0x6C -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = LD8 (R L, R H) }
    | 0x6D -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = LD8 (R L, R L) }
    | 0x6E -> { len = l1; mcycles = { not_branched = 2; branched = 2}; inst = LD8 (R L, RR_indirect HL) }
    | 0x6F -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = LD8 (R L, R A) }
    | 0x70 -> { len = l1; mcycles = { not_branched = 2; branched = 2}; inst = LD8 (RR_indirect HL, R B) }
    | 0x71 -> { len = l1; mcycles = { not_branched = 2; branched = 2}; inst = LD8 (RR_indirect HL, R C) }
    | 0x72 -> { len = l1; mcycles = { not_branched = 2; branched = 2}; inst = LD8 (RR_indirect HL, R D) }
    | 0x73 -> { len = l1; mcycles = { not_branched = 2; branched = 2}; inst = LD8 (RR_indirect HL, R E) }
    | 0x74 -> { len = l1; mcycles = { not_branched = 2; branched = 2}; inst = LD8 (RR_indirect HL, R H) }
    | 0x75 -> { len = l1; mcycles = { not_branched = 2; branched = 2}; inst = LD8 (RR_indirect HL, R L) }
    | 0x76 -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = HALT }
    | 0x77 -> { len = l1; mcycles = { not_branched = 2; branched = 2}; inst = LD8 (RR_indirect HL, R A) }
    | 0x78 -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = LD8 (R A, R B) }
    | 0x79 -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = LD8 (R A, R C) }
    | 0x7A -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = LD8 (R A, R D) }
    | 0x7B -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = LD8 (R A, R E) }
    | 0x7C -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = LD8 (R A, R H) }
    | 0x7D -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = LD8 (R A, R L) }
    | 0x7E -> { len = l1; mcycles = { not_branched = 2; branched = 2}; inst = LD8 (R A, RR_indirect HL) }
    | 0x7F -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = LD8 (R A, R A) }
    | 0x80 -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = ADD8 (R A, R B) }
    | 0x81 -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = ADD8 (R A, R C) }
    | 0x82 -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = ADD8 (R A, R D) }
    | 0x83 -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = ADD8 (R A, R E) }
    | 0x84 -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = ADD8 (R A, R H) }
    | 0x85 -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = ADD8 (R A, R L) }
    | 0x86 -> { len = l1; mcycles = { not_branched = 2; branched = 2}; inst = ADD8 (R A, RR_indirect HL) }
    | 0x87 -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = ADD8 (R A, (R A)) }
    | 0x88 -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = ADC (R A, R B) }
    | 0x89 -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = ADC (R A, R C) }
    | 0x8A -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = ADC (R A, R D) }
    | 0x8B -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = ADC (R A, R E) }
    | 0x8C -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = ADC (R A, R H) }
    | 0x8D -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = ADC (R A, R L) }
    | 0x8E -> { len = l1; mcycles = { not_branched = 2; branched = 2}; inst = ADC (R A, RR_indirect HL) }
    | 0x8F -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = ADC (R A, R A) }
    | 0x90 -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = SUB (R A, R B) }
    | 0x91 -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = SUB (R A, R C) }
    | 0x92 -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = SUB (R A, R D) }
    | 0x93 -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = SUB (R A, R E) }
    | 0x94 -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = SUB (R A, R H) }
    | 0x95 -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = SUB (R A, R L) }
    | 0x96 -> { len = l1; mcycles = { not_branched = 2; branched = 2}; inst = SUB (R A, RR_indirect HL) }
    | 0x97 -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = SUB (R A, R A) }
    | 0x98 -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = SBC (R A, R B) }
    | 0x99 -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = SBC (R A, R C) }
    | 0x9A -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = SBC (R A, R D) }
    | 0x9B -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = SBC (R A, R E) }
    | 0x9C -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = SBC (R A, R H) }
    | 0x9D -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = SBC (R A, R L) }
    | 0x9E -> { len = l1; mcycles = { not_branched = 2; branched = 2}; inst = SBC (R A, RR_indirect HL) }
    | 0x9F -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = SBC (R A, R A) }
    | 0xA0 -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = AND (R A, R B) }
    | 0xA1 -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = AND (R A, R C) }
    | 0xA2 -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = AND (R A, R D) }
    | 0xA3 -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = AND (R A, R E) }
    | 0xA4 -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = AND (R A, R H) }
    | 0xA5 -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = AND (R A, R L) }
    | 0xA6 -> { len = l1; mcycles = { not_branched = 2; branched = 2}; inst = AND (R A, RR_indirect HL) }
    | 0xA7 -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = AND (R A, R A) }
    | 0xA8 -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = XOR (R A, R B) }
    | 0xA9 -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = XOR (R A, R C) }
    | 0xAA -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = XOR (R A, R D) }
    | 0xAB -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = XOR (R A, R E) }
    | 0xAC -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = XOR (R A, R H) }
    | 0xAD -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = XOR (R A, R L) }
    | 0xAE -> { len = l1; mcycles = { not_branched = 2; branched = 2}; inst = XOR (R A, RR_indirect HL) }
    | 0xAF -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = XOR (R A, R A) }
    | 0xB0 -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = OR (R A, R B) }
    | 0xB1 -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = OR (R A, R C) }
    | 0xB2 -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = OR (R A, R D) }
    | 0xB3 -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = OR (R A, R E) }
    | 0xB4 -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = OR (R A, R H) }
    | 0xB5 -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = OR (R A, R L) }
    | 0xB6 -> { len = l1; mcycles = { not_branched = 2; branched = 2}; inst = OR (R A, RR_indirect HL) }
    | 0xB7 -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = OR (R A, R A) }
    | 0xB8 -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = CP (R A, R B) }
    | 0xB9 -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = CP (R A, R C) }
    | 0xBA -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = CP (R A, R D) }
    | 0xBB -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = CP (R A, R E) }
    | 0xBC -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = CP (R A, R H) }
    | 0xBD -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = CP (R A, R L) }
    | 0xBE -> { len = l1; mcycles = { not_branched = 2; branched = 2}; inst = CP (R A, RR_indirect HL) }
    | 0xBF -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = CP (R A, R A) }
    | 0xC0 -> { len = l1; mcycles = { not_branched = 2; branched = 5}; inst = RET NZ }
    | 0xC1 -> { len = l1; mcycles = { not_branched = 3; branched = 3}; inst = POP BC }
    | 0xC2 -> { len = l3; mcycles = { not_branched = 3; branched = 4}; inst = JP (NZ, Immediate16 (next_word ())) }
    | 0xC3 -> { len = l3; mcycles = { not_branched = 4; branched = 4}; inst = JP (None, Immediate16 (next_word ())) }
    | 0xC4 -> { len = l3; mcycles = { not_branched = 3; branched = 6}; inst = CALL (NZ, next_word ()) }
    | 0xC5 -> { len = l1; mcycles = { not_branched = 4; branched = 4}; inst = PUSH BC }
    | 0xC6 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = ADD8 (R A, (Immediate8 (next_byte ()))) }
    | 0xC7 -> { len = l1; mcycles = { not_branched = 4; branched = 4}; inst = RST RST_offset.x00 }
    | 0xC8 -> { len = l1; mcycles = { not_branched = 2; branched = 5}; inst = RET Z }
    | 0xC9 -> { len = l1; mcycles = { not_branched = 4; branched = 4}; inst = RET None }
    | 0xCA -> { len = l3; mcycles = { not_branched = 3; branched = 4}; inst = JP (Z, Immediate16 (next_word ())) }
    | 0xCC -> { len = l3; mcycles = { not_branched = 3; branched = 6}; inst = CALL (Z, next_word ()) }
    | 0xCD -> { len = l3; mcycles = { not_branched = 6; branched = 6}; inst = CALL (None, next_word ()) }
    | 0xCE -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = ADC (R A, Immediate8 (next_byte ())) }
    | 0xCF -> { len = l1; mcycles = { not_branched = 4; branched = 4}; inst = RST RST_offset.x08 }
    | 0xD0 -> { len = l1; mcycles = { not_branched = 2; branched = 5}; inst = RET NC }
    | 0xD1 -> { len = l1; mcycles = { not_branched = 3; branched = 3}; inst = POP DE }
    | 0xD2 -> { len = l3; mcycles = { not_branched = 3; branched = 4}; inst = JP (NC, Immediate16 (next_word ())) }
    | 0xD3 -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = NOP }
    | 0xD4 -> { len = l3; mcycles = { not_branched = 3; branched = 6}; inst = CALL (NC, next_word ()) }
    | 0xD5 -> { len = l1; mcycles = { not_branched = 4; branched = 4}; inst = PUSH DE }
    | 0xD6 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = SUB (R A, Immediate8 (next_byte ())) }
    | 0xD7 -> { len = l1; mcycles = { not_branched = 4; branched = 4}; inst = RST RST_offset.x10 }
    | 0xD8 -> { len = l1; mcycles = { not_branched = 2; branched = 5}; inst = RET C }
    | 0xD9 -> { len = l1; mcycles = { not_branched = 4; branched = 4}; inst = RETI }
    | 0xDA -> { len = l3; mcycles = { not_branched = 3; branched = 4}; inst = JP (C, Immediate16 (next_word ())) }
    | 0xDB -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = NOP }
    | 0xDC -> { len = l3; mcycles = { not_branched = 3; branched = 6}; inst = CALL (C, next_word ()) }
    | 0xDD -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = NOP }
    | 0xDE -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = SBC (R A, Immediate8 (next_byte ())) }
    | 0xDF -> { len = l1; mcycles = { not_branched = 4; branched = 4}; inst = RST RST_offset.x18 }
    | 0xE0 -> { len = l2; mcycles = { not_branched = 3; branched = 3}; inst = LD8 (FF00_offset (next_byte ()), R A) }
    | 0xE1 -> { len = l1; mcycles = { not_branched = 3; branched = 3}; inst = POP HL }
    | 0xE2 -> { len = l1; mcycles = { not_branched = 2; branched = 2}; inst = LD8 (FF00_C, R A) }
    | 0xE3 -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = NOP }
    | 0xE4 -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = NOP }
    | 0xE5 -> { len = l1; mcycles = { not_branched = 4; branched = 4}; inst = PUSH HL }
    | 0xE6 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = AND (R A, Immediate8 (next_byte ())) }
    | 0xE7 -> { len = l1; mcycles = { not_branched = 4; branched = 4}; inst = RST RST_offset.x20 }
    | 0xE8 -> { len = l2; mcycles = { not_branched = 4; branched = 4}; inst = ADDSP (next_byte () |> Int8.of_byte) }
    | 0xE9 -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = JP (None, RR HL) }
    | 0xEA -> { len = l3; mcycles = { not_branched = 4; branched = 4}; inst = LD8 (Direct8 (next_word ()), R A) }
    | 0xEB -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = NOP }
    | 0xEC -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = NOP }
    | 0xED -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = NOP }
    | 0xEE -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = XOR (R A, Immediate8 (next_byte ())) }
    | 0xEF -> { len = l1; mcycles = { not_branched = 4; branched = 4}; inst = RST RST_offset.x28 }
    | 0xF0 -> { len = l2; mcycles = { not_branched = 3; branched = 3}; inst = LD8 (R A, FF00_offset (next_byte ())) }
    | 0xF1 -> { len = l1; mcycles = { not_branched = 3; branched = 3}; inst = POP AF }
    | 0xF2 -> { len = l1; mcycles = { not_branched = 2; branched = 2}; inst = LD8 (R A, FF00_C) }
    | 0xF3 -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = DI }
    | 0xF4 -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = NOP }
    | 0xF5 -> { len = l1; mcycles = { not_branched = 4; branched = 4}; inst = PUSH AF }
    | 0xF6 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = OR (R A, Immediate8 (next_byte ())) }
    | 0xF7 -> { len = l1; mcycles = { not_branched = 4; branched = 4}; inst = RST RST_offset.x30 }
    | 0xF8 -> { len = l2; mcycles = { not_branched = 3; branched = 3}; inst = LD16 (RR HL, SP_offset (Int8.of_byte @@ next_byte ())) }
    | 0xF9 -> { len = l1; mcycles = { not_branched = 2; branched = 2}; inst = LD16 (SP, RR HL) }
    | 0xFA -> { len = l3; mcycles = { not_branched = 4; branched = 4}; inst = LD8 (R A, Direct8 (next_word ())) }
    | 0xFB -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = EI }
    | 0xFC -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = NOP }
    | 0xFD -> { len = l1; mcycles = { not_branched = 1; branched = 1}; inst = NOP }
    | 0xFE -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = CP (R A, Immediate8 (next_byte ())) }
    | 0xFF -> { len = l1; mcycles = { not_branched = 4; branched = 4}; inst = RST RST_offset.x38 }
    | 0xCB -> begin
        let op = next_byte () |> Uint8.to_int in
        match op with
        | 0x00 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = RLC (R B) }
        | 0x01 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = RLC (R C) }
        | 0x02 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = RLC (R D) }
        | 0x03 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = RLC (R E) }
        | 0x04 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = RLC (R H) }
        | 0x05 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = RLC (R L) }
        | 0x06 -> { len = l2; mcycles = { not_branched = 4; branched = 4}; inst = RLC (RR_indirect HL) }
        | 0x07 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = RLC (R A) }
        | 0x08 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = RRC (R B) }
        | 0x09 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = RRC (R C) }
        | 0x0A -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = RRC (R D) }
        | 0x0B -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = RRC (R E) }
        | 0x0C -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = RRC (R H) }
        | 0x0D -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = RRC (R L) }
        | 0x0E -> { len = l2; mcycles = { not_branched = 4; branched = 4}; inst = RRC (RR_indirect HL) }
        | 0x0F -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = RRC (R A) }
        | 0x10 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = RL (R B) }
        | 0x11 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = RL (R C) }
        | 0x12 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = RL (R D) }
        | 0x13 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = RL (R E) }
        | 0x14 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = RL (R H) }
        | 0x15 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = RL (R L) }
        | 0x16 -> { len = l2; mcycles = { not_branched = 4; branched = 4}; inst = RL (RR_indirect HL) }
        | 0x17 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = RL (R A) }
        | 0x18 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = RR (R B) }
        | 0x19 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = RR (R C) }
        | 0x1A -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = RR (R D) }
        | 0x1B -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = RR (R E) }
        | 0x1C -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = RR (R H) }
        | 0x1D -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = RR (R L) }
        | 0x1E -> { len = l2; mcycles = { not_branched = 4; branched = 4}; inst = RR (RR_indirect HL) }
        | 0x1F -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = RR (R A) }
        | 0x20 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = SLA (R B) }
        | 0x21 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = SLA (R C) }
        | 0x22 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = SLA (R D) }
        | 0x23 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = SLA (R E) }
        | 0x24 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = SLA (R H) }
        | 0x25 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = SLA (R L) }
        | 0x26 -> { len = l2; mcycles = { not_branched = 4; branched = 4}; inst = SLA (RR_indirect HL) }
        | 0x27 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = SLA (R A) }
        | 0x28 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = SRA (R B) }
        | 0x29 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = SRA (R C) }
        | 0x2A -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = SRA (R D) }
        | 0x2B -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = SRA (R E) }
        | 0x2C -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = SRA (R H) }
        | 0x2D -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = SRA (R L) }
        | 0x2E -> { len = l2; mcycles = { not_branched = 4; branched = 4}; inst = SRA (RR_indirect HL) }
        | 0x2F -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = SRA (R A) }
        | 0x30 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = SWAP (R B) }
        | 0x31 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = SWAP (R C) }
        | 0x32 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = SWAP (R D) }
        | 0x33 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = SWAP (R E) }
        | 0x34 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = SWAP (R H) }
        | 0x35 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = SWAP (R L) }
        | 0x36 -> { len = l2; mcycles = { not_branched = 4; branched = 4}; inst = SWAP (RR_indirect HL) }
        | 0x37 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = SWAP (R A) }
        | 0x38 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = SRL (R B) }
        | 0x39 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = SRL (R C) }
        | 0x3A -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = SRL (R D) }
        | 0x3B -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = SRL (R E) }
        | 0x3C -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = SRL (R H) }
        | 0x3D -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = SRL (R L) }
        | 0x3E -> { len = l2; mcycles = { not_branched = 4; branched = 4}; inst = SRL (RR_indirect HL) }
        | 0x3F -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = SRL (R A) }
        | 0x40 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = BIT (0, R B) }
        | 0x41 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = BIT (0, R C) }
        | 0x42 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = BIT (0, R D) }
        | 0x43 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = BIT (0, R E) }
        | 0x44 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = BIT (0, R H) }
        | 0x45 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = BIT (0, R L) }
        | 0x46 -> { len = l2; mcycles = { not_branched = 3; branched = 3}; inst = BIT (0, RR_indirect HL) }
        | 0x47 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = BIT (0, R A) }
        | 0x48 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = BIT (1, R B) }
        | 0x49 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = BIT (1, R C) }
        | 0x4A -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = BIT (1, R D) }
        | 0x4B -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = BIT (1, R E) }
        | 0x4C -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = BIT (1, R H) }
        | 0x4D -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = BIT (1, R L) }
        | 0x4E -> { len = l2; mcycles = { not_branched = 3; branched = 3}; inst = BIT (1, RR_indirect HL) }
        | 0x4F -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = BIT (1, R A) }
        | 0x50 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = BIT (2, R B) }
        | 0x51 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = BIT (2, R C) }
        | 0x52 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = BIT (2, R D) }
        | 0x53 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = BIT (2, R E) }
        | 0x54 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = BIT (2, R H) }
        | 0x55 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = BIT (2, R L) }
        | 0x56 -> { len = l2; mcycles = { not_branched = 3; branched = 3}; inst = BIT (2, RR_indirect HL) }
        | 0x57 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = BIT (2, R A) }
        | 0x58 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = BIT (3, R B) }
        | 0x59 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = BIT (3, R C) }
        | 0x5A -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = BIT (3, R D) }
        | 0x5B -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = BIT (3, R E) }
        | 0x5C -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = BIT (3, R H) }
        | 0x5D -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = BIT (3, R L) }
        | 0x5E -> { len = l2; mcycles = { not_branched = 3; branched = 3}; inst = BIT (3, RR_indirect HL) }
        | 0x5F -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = BIT (3, R A) }
        | 0x60 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = BIT (4, R B) }
        | 0x61 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = BIT (4, R C) }
        | 0x62 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = BIT (4, R D) }
        | 0x63 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = BIT (4, R E) }
        | 0x64 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = BIT (4, R H) }
        | 0x65 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = BIT (4, R L) }
        | 0x66 -> { len = l2; mcycles = { not_branched = 3; branched = 3}; inst = BIT (4, RR_indirect HL) }
        | 0x67 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = BIT (4, R A) }
        | 0x68 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = BIT (5, R B) }
        | 0x69 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = BIT (5, R C) }
        | 0x6A -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = BIT (5, R D) }
        | 0x6B -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = BIT (5, R E) }
        | 0x6C -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = BIT (5, R H) }
        | 0x6D -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = BIT (5, R L) }
        | 0x6E -> { len = l2; mcycles = { not_branched = 3; branched = 3}; inst = BIT (5, RR_indirect HL) }
        | 0x6F -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = BIT (5, R A) }
        | 0x70 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = BIT (6, R B) }
        | 0x71 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = BIT (6, R C) }
        | 0x72 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = BIT (6, R D) }
        | 0x73 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = BIT (6, R E) }
        | 0x74 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = BIT (6, R H) }
        | 0x75 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = BIT (6, R L) }
        | 0x76 -> { len = l2; mcycles = { not_branched = 3; branched = 3}; inst = BIT (6, RR_indirect HL) }
        | 0x77 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = BIT (6, R A) }
        | 0x78 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = BIT (7, R B) }
        | 0x79 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = BIT (7, R C) }
        | 0x7A -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = BIT (7, R D) }
        | 0x7B -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = BIT (7, R E) }
        | 0x7C -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = BIT (7, R H) }
        | 0x7D -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = BIT (7, R L) }
        | 0x7E -> { len = l2; mcycles = { not_branched = 3; branched = 3}; inst = BIT (7, RR_indirect HL) }
        | 0x7F -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = BIT (7, R A) }
        | 0x80 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = RES (0, R B) }
        | 0x81 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = RES (0, R C) }
        | 0x82 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = RES (0, R D) }
        | 0x83 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = RES (0, R E) }
        | 0x84 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = RES (0, R H) }
        | 0x85 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = RES (0, R L) }
        | 0x86 -> { len = l2; mcycles = { not_branched = 4; branched = 4}; inst = RES (0, RR_indirect HL) }
        | 0x87 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = RES (0, R A) }
        | 0x88 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = RES (1, R B) }
        | 0x89 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = RES (1, R C) }
        | 0x8A -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = RES (1, R D) }
        | 0x8B -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = RES (1, R E) }
        | 0x8C -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = RES (1, R H) }
        | 0x8D -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = RES (1, R L) }
        | 0x8E -> { len = l2; mcycles = { not_branched = 4; branched = 4}; inst = RES (1, RR_indirect HL) }
        | 0x8F -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = RES (1, R A) }
        | 0x90 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = RES (2, R B) }
        | 0x91 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = RES (2, R C) }
        | 0x92 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = RES (2, R D) }
        | 0x93 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = RES (2, R E) }
        | 0x94 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = RES (2, R H) }
        | 0x95 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = RES (2, R L) }
        | 0x96 -> { len = l2; mcycles = { not_branched = 4; branched = 4}; inst = RES (2, RR_indirect HL) }
        | 0x97 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = RES (2, R A) }
        | 0x98 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = RES (3, R B) }
        | 0x99 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = RES (3, R C) }
        | 0x9A -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = RES (3, R D) }
        | 0x9B -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = RES (3, R E) }
        | 0x9C -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = RES (3, R H) }
        | 0x9D -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = RES (3, R L) }
        | 0x9E -> { len = l2; mcycles = { not_branched = 4; branched = 4}; inst = RES (3, RR_indirect HL) }
        | 0x9F -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = RES (3, R A) }
        | 0xA0 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = RES (4, R B) }
        | 0xA1 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = RES (4, R C) }
        | 0xA2 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = RES (4, R D) }
        | 0xA3 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = RES (4, R E) }
        | 0xA4 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = RES (4, R H) }
        | 0xA5 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = RES (4, R L) }
        | 0xA6 -> { len = l2; mcycles = { not_branched = 4; branched = 4}; inst = RES (4, RR_indirect HL) }
        | 0xA7 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = RES (4, R A) }
        | 0xA8 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = RES (5, R B) }
        | 0xA9 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = RES (5, R C) }
        | 0xAA -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = RES (5, R D) }
        | 0xAB -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = RES (5, R E) }
        | 0xAC -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = RES (5, R H) }
        | 0xAD -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = RES (5, R L) }
        | 0xAE -> { len = l2; mcycles = { not_branched = 4; branched = 4}; inst = RES (5, RR_indirect HL) }
        | 0xAF -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = RES (5, R A) }
        | 0xB0 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = RES (6, R B) }
        | 0xB1 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = RES (6, R C) }
        | 0xB2 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = RES (6, R D) }
        | 0xB3 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = RES (6, R E) }
        | 0xB4 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = RES (6, R H) }
        | 0xB5 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = RES (6, R L) }
        | 0xB6 -> { len = l2; mcycles = { not_branched = 4; branched = 4}; inst = RES (6, RR_indirect HL) }
        | 0xB7 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = RES (6, R A) }
        | 0xB8 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = RES (7, R B) }
        | 0xB9 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = RES (7, R C) }
        | 0xBA -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = RES (7, R D) }
        | 0xBB -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = RES (7, R E) }
        | 0xBC -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = RES (7, R H) }
        | 0xBD -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = RES (7, R L) }
        | 0xBE -> { len = l2; mcycles = { not_branched = 4; branched = 4}; inst = RES (7, RR_indirect HL) }
        | 0xBF -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = RES (7, R A) }
        | 0xC0 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = SET (0, R B) }
        | 0xC1 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = SET (0, R C) }
        | 0xC2 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = SET (0, R D) }
        | 0xC3 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = SET (0, R E) }
        | 0xC4 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = SET (0, R H) }
        | 0xC5 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = SET (0, R L) }
        | 0xC6 -> { len = l2; mcycles = { not_branched = 4; branched = 4}; inst = SET (0, RR_indirect HL) }
        | 0xC7 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = SET (0, R A) }
        | 0xC8 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = SET (1, R B) }
        | 0xC9 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = SET (1, R C) }
        | 0xCA -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = SET (1, R D) }
        | 0xCB -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = SET (1, R E) }
        | 0xCC -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = SET (1, R H) }
        | 0xCD -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = SET (1, R L) }
        | 0xCE -> { len = l2; mcycles = { not_branched = 4; branched = 4}; inst = SET (1, RR_indirect HL) }
        | 0xCF -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = SET (1, R A) }
        | 0xD0 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = SET (2, R B) }
        | 0xD1 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = SET (2, R C) }
        | 0xD2 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = SET (2, R D) }
        | 0xD3 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = SET (2, R E) }
        | 0xD4 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = SET (2, R H) }
        | 0xD5 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = SET (2, R L) }
        | 0xD6 -> { len = l2; mcycles = { not_branched = 4; branched = 4}; inst = SET (2, RR_indirect HL) }
        | 0xD7 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = SET (2, R A) }
        | 0xD8 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = SET (3, R B) }
        | 0xD9 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = SET (3, R C) }
        | 0xDA -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = SET (3, R D) }
        | 0xDB -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = SET (3, R E) }
        | 0xDC -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = SET (3, R H) }
        | 0xDD -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = SET (3, R L) }
        | 0xDE -> { len = l2; mcycles = { not_branched = 4; branched = 4}; inst = SET (3, RR_indirect HL) }
        | 0xDF -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = SET (3, R A) }
        | 0xE0 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = SET (4, R B) }
        | 0xE1 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = SET (4, R C) }
        | 0xE2 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = SET (4, R D) }
        | 0xE3 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = SET (4, R E) }
        | 0xE4 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = SET (4, R H) }
        | 0xE5 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = SET (4, R L) }
        | 0xE6 -> { len = l2; mcycles = { not_branched = 4; branched = 4}; inst = SET (4, RR_indirect HL) }
        | 0xE7 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = SET (4, R A) }
        | 0xE8 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = SET (5, R B) }
        | 0xE9 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = SET (5, R C) }
        | 0xEA -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = SET (5, R D) }
        | 0xEB -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = SET (5, R E) }
        | 0xEC -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = SET (5, R H) }
        | 0xED -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = SET (5, R L) }
        | 0xEE -> { len = l2; mcycles = { not_branched = 4; branched = 4}; inst = SET (5, RR_indirect HL) }
        | 0xEF -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = SET (5, R A) }
        | 0xF0 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = SET (6, R B) }
        | 0xF1 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = SET (6, R C) }
        | 0xF2 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = SET (6, R D) }
        | 0xF3 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = SET (6, R E) }
        | 0xF4 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = SET (6, R H) }
        | 0xF5 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = SET (6, R L) }
        | 0xF6 -> { len = l2; mcycles = { not_branched = 4; branched = 4}; inst = SET (6, RR_indirect HL) }
        | 0xF7 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = SET (6, R A) }
        | 0xF8 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = SET (7, R B) }
        | 0xF9 -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = SET (7, R C) }
        | 0xFA -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = SET (7, R D) }
        | 0xFB -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = SET (7, R E) }
        | 0xFC -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = SET (7, R H) }
        | 0xFD -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = SET (7, R L) }
        | 0xFE -> { len = l2; mcycles = { not_branched = 4; branched = 4}; inst = SET (7, RR_indirect HL) }
        | 0xFF -> { len = l2; mcycles = { not_branched = 2; branched = 2}; inst = SET (7, R A) }
        | _ -> failwith (Printf.sprintf "Unrecognized opcode after 0xCB: 0x%02x" op)
      end
    | _ -> failwith (Printf.sprintf "Unrecognized opcode: 0x%02x" op)
end
