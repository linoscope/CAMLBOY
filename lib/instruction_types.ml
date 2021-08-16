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

let print_jp = fun fmt (c, x) ->
  match c with
  | None -> Format.fprintf fmt "JP %s" (show_arg16 x)
  | NZ | Z | NC | C -> Format.fprintf fmt "JP %s, %s" (show_condition c) (show_arg16 x)

let print_call = fun fmt (c, x) ->
  match c with
  | None -> Format.fprintf fmt "CALL %s" (show_uint16 x)
  | NZ | Z | NC | C -> Format.fprintf fmt "CALL %s, %s" (show_condition c) (show_uint16 x)

let print_jr = fun fmt (c, x) ->
  match c with
  | None -> Format.fprintf fmt "JR %s" (show_uint8 x)
  | NZ | Z | NC | C -> Format.fprintf fmt "JR %s, %s" (show_condition c) (show_uint8 x)

type t =
  | LD of arg * arg
          [@printer fun fmt (l,r) -> fprintf fmt "LD %s, %s" (show_arg l) (show_arg r)]
  | LD16 of arg16 * arg16
            [@printer fun fmt (l,r) -> fprintf fmt "LD %s, %s" (show_arg16 l) (show_arg16 r)]
  | PUSH of Registers.rr
            [@printer fun fmt rr -> fprintf fmt "PUSH %s" (Registers.show_rr rr)]
  | POP of Registers.rr
           [@printer fun fmt rr -> fprintf fmt "POP %s" (Registers.show_rr rr)]
  | ADD of arg * arg
           [@printer fun fmt (l,r) -> fprintf fmt "ADD %s, %s" (show_arg l) (show_arg r)]
  | ADD16 of arg16 * arg16
             [@printer fun fmt (l,r) -> fprintf fmt "ADD %s, %s" (show_arg16 l) (show_arg16 r)]
  | ADC of arg * arg
           [@printer fun fmt (l,r) -> fprintf fmt "ADC %s, %s" (show_arg l) (show_arg r)]
  | SUB of arg * arg
           [@printer fun fmt (l,r) -> fprintf fmt "SUB %s, %s" (show_arg l) (show_arg r)]
  | SBC of arg * arg
           [@printer fun fmt (l,r) -> fprintf fmt "SBC %s, %s" (show_arg l) (show_arg r)]
  | AND of arg * arg
           [@printer fun fmt (l,r) -> fprintf fmt "AND %s, %s" (show_arg l) (show_arg r)]
  | OR of arg * arg
          [@printer fun fmt (l,r) -> fprintf fmt "OR %s, %s" (show_arg l) (show_arg r)]
  | XOR of arg * arg
           [@printer fun fmt (l,r) -> fprintf fmt "XOR %s, %s" (show_arg l) (show_arg r)]
  | CP of arg * arg
          [@printer fun fmt (l,r) -> fprintf fmt "CP %s, %s" (show_arg l) (show_arg r)]
  | INC of arg
           [@printer fun fmt x -> fprintf fmt "INC %s" (show_arg x)]
  | INC16 of arg16
             [@printer fun fmt x -> fprintf fmt "INC %s" (show_arg16 x)]
  | DEC of arg
           [@printer fun fmt x -> fprintf fmt "DEC %s" (show_arg x)]
  | DEC16 of arg16
             [@printer fun fmt x -> fprintf fmt "DEC %s" (show_arg16 x)]
  | SWAP of arg
            [@printer fun fmt x -> fprintf fmt "SWAP %s" (show_arg x)]
  | DAA                        [@printer fun fmt _ -> fprintf fmt "DAA"]
  | CPL                        [@printer fun fmt _ -> fprintf fmt "CPL"]
  | CCF                        [@printer fun fmt _ -> fprintf fmt "CCF"]
  | SCF                        [@printer fun fmt _ -> fprintf fmt "SCF"]
  | NOP                        [@printer fun fmt _ -> fprintf fmt "NOP"]
  | HALT                       [@printer fun fmt _ -> fprintf fmt "HALT"]
  | STOP                       [@printer fun fmt _ -> fprintf fmt "STOP"]
  | DI                         [@printer fun fmt _ -> fprintf fmt "DI"]
  | EI                         [@printer fun fmt _ -> fprintf fmt "EI"]
  | RLCA                       [@printer fun fmt _ -> fprintf fmt "RLCA"]
  | RLA                        [@printer fun fmt _ -> fprintf fmt "RLA"]
  | RRCA                       [@printer fun fmt _ -> fprintf fmt "RRCA"]
  | RRA                        [@printer fun fmt _ -> fprintf fmt "RRA"]
  | RLC of arg                 [@printer fun fmt x -> fprintf fmt "RLC %s" (show_arg x)]
  | RL of arg                  [@printer fun fmt x -> fprintf fmt "RL %s" (show_arg x)]
  | RRC of arg                 [@printer fun fmt x -> fprintf fmt "RRC %s" (show_arg x)]
  | RR of arg                  [@printer fun fmt x -> fprintf fmt "RR %s" (show_arg x)]
  | SLA of arg                 [@printer fun fmt x -> fprintf fmt "SLA %s" (show_arg x)]
  | SRA of arg                 [@printer fun fmt x -> fprintf fmt "SRA %s" (show_arg x)]
  | SRL of arg                 [@printer fun fmt x -> fprintf fmt "SRL %s" (show_arg x)]
  | BIT of uint8 * arg         [@printer fun fmt (n,x) -> fprintf fmt "BIT %s, %s" (show_uint8 n) (show_arg x)]
  | SET of uint8 * arg         [@printer fun fmt (n,x) -> fprintf fmt "SET %s, %s" (show_uint8 n) (show_arg x)]
  | RES of uint8 * arg         [@printer fun fmt (n,x) -> fprintf fmt "RES %s, %s" (show_uint8 n) (show_arg x)]
  | JP of condition * arg16    [@printer print_jp]
  | JR of condition * uint8    [@printer print_jr]
  | CALL of condition * uint16 [@printer print_call]
  | RST of uint16              [@printer fun fmt x -> fprintf fmt "RST %s" (show_uint16 x)]
  | RET of condition           [@printer fun fmt c -> fprintf fmt "RET %s" (show_condition c)]
  | RETI                       [@printer fun fmt _ -> fprintf fmt "RETI"]
[@@deriving show]
