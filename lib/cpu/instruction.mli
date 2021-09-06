open Uints

type 'a arg =
  | Immediate8  : uint8        -> uint8  arg
  | Immediate16 : uint16       -> uint16 arg
  | Direct8     : uint16       -> uint8  arg
  | Direct16    : uint16       -> uint16 arg
  | R           : Registers.r  -> uint8  arg
  | RR          : Registers.rr -> uint16 arg
  | RR_indirect : Registers.rr -> uint8  arg
  | FF00_offset : uint8        -> uint8  arg
  | FF00_C      : uint8 arg
  | HL_inc      : uint8 arg
  | HL_dec      : uint8 arg
  | SP          : uint16 arg
  | SP_offset   : int8         -> uint16 arg

type condition =
  | None
  | NZ
  | Z
  | NC
  | C

type t =
  | LD8   of uint8 arg * uint8 arg
  | LD16  of uint16 arg * uint16 arg
  | ADD8  of uint8 arg * uint8 arg
  | ADD16 of uint16 arg * uint16 arg
  | ADDSP of int8
  | ADC   of uint8 arg * uint8 arg
  | SUB   of uint8 arg * uint8 arg
  | SBC   of uint8 arg * uint8 arg
  | AND   of uint8 arg * uint8 arg
  | OR    of uint8 arg * uint8 arg
  | XOR   of uint8 arg * uint8 arg
  | CP    of uint8 arg * uint8 arg
  | INC   of uint8 arg
  | INC16 of uint16 arg
  | DEC   of uint8 arg
  | DEC16 of uint16 arg
  | SWAP  of uint8 arg
  | DAA
  | CPL
  | CCF
  | SCF
  | NOP
  | HALT
  | STOP
  | DI
  | EI
  | RLCA
  | RLA
  | RRCA
  | RRA
  | RLC   of uint8 arg
  | RL    of uint8 arg
  | RRC   of uint8 arg
  | RR    of uint8 arg
  | SLA   of uint8 arg
  | SRA   of uint8 arg
  | SRL   of uint8 arg
  | BIT   of int * uint8 arg
  | SET   of int * uint8 arg
  | RES   of int * uint8 arg
  | PUSH  of Registers.rr
  | POP   of Registers.rr
  | JP    of condition * uint16 arg
  | JR    of condition * int8
  | CALL  of condition * uint16
  | RST   of uint16
  | RET   of condition
  | RETI
[@@deriving show]
