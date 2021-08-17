open Ints

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
  | PUSH of Registers.rr
  | POP of Registers.rr
  | ADD of arg * arg
  | ADC of arg * arg
  | SUB of arg * arg
  | SBC of arg * arg
  | AND of arg * arg
  | OR of arg * arg
  | XOR of arg * arg
  | CP of arg * arg
  | INC of arg
  | DEC of arg
  | SWAP of arg
  | LD16 of arg16 * arg16
  | ADD16 of arg16 * arg16
  | DEC16 of arg16
  | INC16 of arg16
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
  | JP of condition * arg16
  | JR of condition * uint8
  | CALL of condition * uint16
  | RST of uint16
  | RET of condition
  | RETI
[@@deriving show]

let show = function
  | LD (x, y)    -> Printf.sprintf "LD %s, %s" (show_arg x) (show_arg y)
  | PUSH rr      -> Printf.sprintf "PUSH %s" (Registers.show_rr rr)
  | POP rr       -> Printf.sprintf "POP %s" (Registers.show_rr rr)
  | ADD (x, y)   -> Printf.sprintf "ADD %s, %s" (show_arg x) (show_arg y)
  | ADC (x, y)   -> Printf.sprintf "ADC %s, %s" (show_arg x) (show_arg y)
  | SUB (x, y)   -> Printf.sprintf "SUB %s, %s" (show_arg x) (show_arg y)
  | SBC (x, y)   -> Printf.sprintf "SBC %s, %s" (show_arg x) (show_arg y)
  | AND (x, y)   -> Printf.sprintf "AND %s, %s" (show_arg x) (show_arg y)
  | OR (x, y)    -> Printf.sprintf "OR %s, %s" (show_arg x) (show_arg y)
  | XOR (x, y)   -> Printf.sprintf "XOR %s, %s" (show_arg x) (show_arg y)
  | CP (x, y)    -> Printf.sprintf "CP %s, %s" (show_arg x) (show_arg y)
  | INC x        -> Printf.sprintf "INC %s" (show_arg x)
  | DEC x        -> Printf.sprintf "DEC %s" (show_arg x)
  | SWAP x       -> Printf.sprintf "SWAP %s" (show_arg x)
  | ADD16 (x, y) -> Printf.sprintf "ADD %s, %s" (show_arg16 x) (show_arg16 y)
  | LD16 (x, y)  -> Printf.sprintf "LD %s, %s" (show_arg16 x) (show_arg16 y)
  | INC16 x      -> Printf.sprintf "INC %s" (show_arg16 x)
  | DEC16 x      -> Printf.sprintf "DEC %s" (show_arg16 x)
  | DAA          -> Printf.sprintf "DAA"
  | CPL          -> Printf.sprintf "CPL"
  | CCF          -> Printf.sprintf "CCF"
  | SCF          -> Printf.sprintf "SCF"
  | NOP          -> Printf.sprintf "NOP"
  | HALT         -> Printf.sprintf "HALT"
  | STOP         -> Printf.sprintf "STOP"
  | DI           -> Printf.sprintf "DI"
  | EI           -> Printf.sprintf "EI"
  | RLCA         -> Printf.sprintf "RLCA"
  | RLA          -> Printf.sprintf "RLA"
  | RRCA         -> Printf.sprintf "RRCA"
  | RRA          -> Printf.sprintf "RRA"
  | RLC x        -> Printf.sprintf "RLC %s" (show_arg x)
  | RL x         -> Printf.sprintf "RL %s" (show_arg x)
  | RRC x        -> Printf.sprintf "RRC %s" (show_arg x)
  | RR x         -> Printf.sprintf "RR %s" (show_arg x)
  | SLA x        -> Printf.sprintf "SLA %s" (show_arg x)
  | SRA x        -> Printf.sprintf "SRA %s" (show_arg x)
  | SRL x        -> Printf.sprintf "SRL %s" (show_arg x)
  | BIT (n, x)   -> Printf.sprintf "BIT %s, %s" (show_uint8 n) (show_arg x)
  | SET (n, x)   -> Printf.sprintf "SET %s, %s" (show_uint8 n) (show_arg x)
  | RES (n, x)   -> Printf.sprintf "RES %s, %s" (show_uint8 n) (show_arg x)
  | JP (c, x) -> (
      match c with
      | None -> Printf.sprintf "JP %s" (show_arg16 x)
      | NZ | Z | NC | C -> Printf.sprintf "JP %s, %s" (show_condition c) (show_arg16 x))
  | JR (c, x) -> (
      match c with
      | None -> Printf.sprintf "JR %s" (show_uint8 x)
      | NZ | Z | NC | C -> Printf.sprintf "JR %s, %s" (show_condition c) (show_uint8 x))
  | CALL (c, x) -> (
      match c with
      | None -> Printf.sprintf "CALL %s" (show_uint16 x)
      | NZ | Z | NC | C -> Printf.sprintf "CALL %s, %s" (show_condition c) (show_uint16 x))
  | RST x -> Printf.sprintf "RST %s" (show_uint16 x)
  | RET c -> Printf.sprintf "RET %s" (show_condition c)
  | RETI  -> Printf.sprintf "RETI"
