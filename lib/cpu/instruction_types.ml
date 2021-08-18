open Uints

type arg =
  | Immediate of uint8          [@printer fun fmt x -> fprintf fmt "%s" (Uint8.show x)]
  | R of Registers.r            [@printer fun fmt x -> fprintf fmt "%s" (Registers.show_r x)]
  | RR_indirect of Registers.rr [@printer fun fmt x -> fprintf fmt "(%s)" (Registers.show_rr x)]
  | Direct of uint16            [@printer fun fmt x -> fprintf fmt "(%s)" (Uint16.show x)]
  | FF00_offset of uint8        [@printer fun fmt x -> fprintf fmt "(0xFF00+%s)" (Uint8.show x)]
  | FF00_C                      [@printer fun fmt _ -> fprintf fmt "(0xFF00+C)"]
  | HL_inc                      [@printer fun fmt _ -> fprintf fmt "(HL+)"]
  | HL_dec                      [@printer fun fmt _ -> fprintf fmt "(HL-)"]
[@@deriving show]

type arg16 =
  | Immediate of uint16 [@printer fun fmt x -> fprintf fmt "%s" (Uint16.show x)]
  | Immediate8 of uint8 [@printer fun fmt x -> fprintf fmt "%s" (Uint8.show x)]
  | Direct of uint16    [@printer fun fmt x -> fprintf fmt "(%s)" (Uint16.show x)]
  | RR of Registers.rr  [@printer fun fmt x -> fprintf fmt "%s" (Registers.show_rr x)]
  | SP                  [@printer fun fmt _ -> fprintf fmt "SP"]
  | SP_offset of uint8  [@printer fun fmt x -> fprintf fmt "SP+%s" (Uint8.show x)]
[@@deriving show]

type condition =
  | None [@printer fun fmt _ -> fprintf fmt ""]
  | NZ [@printer fun fmt _ -> fprintf fmt "NZ"]
  | Z  [@printer fun fmt _ -> fprintf fmt "Z"]
  | NC [@printer fun fmt _ -> fprintf fmt "NC"]
  | C  [@printer fun fmt _ -> fprintf fmt "C"]
[@@deriving show]

type t =
  | LD of arg * arg
  | LD16 of arg16 * arg16
  | ADD of arg * arg
  | ADD16 of arg16 * arg16
  | ADC of arg * arg
  | SUB of arg * arg
  | SBC of arg * arg
  | AND of arg * arg
  | OR of arg * arg
  | XOR of arg * arg
  | CP of arg * arg
  | INC of arg
  | INC16 of arg16
  | DEC of arg
  | DEC16 of arg16
  | SWAP of arg
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
  | RLC of arg
  | RL of arg
  | RRC of arg
  | RR of arg
  | SLA of arg
  | SRA of arg
  | SRL of arg
  | BIT of uint8 * arg
  | SET of uint8 * arg
  | RES of uint8 * arg
  | PUSH of Registers.rr
  | POP of Registers.rr
  | JP of condition * arg16
  | JR of condition * uint8
  | CALL of condition * uint16
  | RST of uint16
  | RET of condition
  | RETI
[@@deriving show]
