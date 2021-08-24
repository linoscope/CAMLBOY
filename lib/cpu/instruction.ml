open Uints

type 'a arg =
  | Immediate8  : uint8 -> uint8  arg
  | Immediate16 : uint16 -> uint16 arg
  | Direct8     : uint16 -> uint8  arg
  | Direct16    : uint16 -> uint16 arg
  | R           : Registers.r -> uint8  arg
  | RR          : Registers.rr -> uint16 arg
  | RR_indirect : Registers.rr -> uint8  arg
  | FF00_offset : uint8 -> uint8  arg
  | FF00_C      : uint8 arg
  | HL_inc      : uint8 arg
  | HL_dec      : uint8 arg
  | SP          : uint16 arg
  | SP_offset   : uint8 -> uint16 arg

type condition =
  | None
  | NZ
  | Z
  | NC
  | C

type 'a t =
  | LD    : 'a arg * 'a arg -> 'a t
  | ADD8  : uint8 arg * uint8 arg -> 'a t
  | ADD16 : uint16 arg * uint16 arg -> 'a t
  | ADC   : uint8 arg * uint8 arg -> 'a t
  | SUB   : uint8 arg * uint8 arg -> 'a t
  | SBC   : uint8 arg * uint8 arg -> 'a t
  | AND   : uint8 arg * uint8 arg -> 'a t
  | OR    : uint8 arg * uint8 arg -> 'a t
  | XOR   : uint8 arg * uint8 arg -> 'a t
  | CP    : uint8 arg * uint8 arg -> 'a t
  | INC   : uint8 arg -> 'a t
  | INC16 : uint16 arg -> 'a t
  | DEC   : uint8 arg -> 'a t
  | DEC16 : uint16 arg -> 'a t
  | SWAP  : uint8 arg -> 'a t
  | DAA   : 'a t
  | CPL   : 'a t
  | CCF   : 'a t
  | SCF   : 'a t
  | NOP   : 'a t
  | HALT  : 'a t
  | STOP  : 'a t
  | DI    : 'a t
  | EI    : 'a t
  | RLCA  : 'a t
  | RLA   : 'a t
  | RRCA  : 'a t
  | RRA   : 'a t
  | RLC   : uint8 arg -> 'a t
  | RL    : uint8 arg -> 'a t
  | RRC   : uint8 arg -> 'a t
  | RR    : uint8 arg -> 'a t
  | SLA   : uint8 arg -> 'a t
  | SRA   : uint8 arg -> 'a t
  | SRL   : uint8 arg -> 'a t
  | BIT   : uint8 * uint8 arg -> 'a t
  | SET   : uint8 * uint8 arg -> 'a t
  | RES   : uint8 * uint8 arg -> 'a t
  | PUSH  : Registers.rr -> 'a t
  | POP   : Registers.rr -> 'a t
  | JP    : condition * uint16 arg -> 'a t
  | JR    : condition * uint8 -> 'a t
  | CALL  : condition * uint16 -> 'a t
  | RST   : uint16 -> 'a t
  | RET   : condition -> 'a t
  | RETI  : 'a t
