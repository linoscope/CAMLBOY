open Ints

type load_term =
  | Immediate8 of uint8         (* Ex. 0x9A *)          [@printer pp_uint8]
  | Immediate16 of uint16       (* Ex. 0x9ABC *)        [@printer pp_uint16]
  | R_direct of Registers.r     (* Ex. A *)             [@printer Registers.pp_r]
  | RR_direct of Registers.rr   (* Ex. BC *)            [@printer Registers.pp_rr]
  | RR_indirect of Registers.rr (* Ex. (BC) *)          [@printer fun fmt rr -> fprintf fmt "(%s)" (Registers.show_rr rr)]
  | Direct of uint16            (* Ex. (0x9ABC) *)      [@printer fun fmt x -> fprintf fmt "(%s)" (show_uint16 x)]
  | FF00_offset of uint8        (* Ex. (0xFF00+0x10) *) [@printer fun fmt x -> fprintf fmt "(0xFF00+%s)" (show_uint8 x)]
  | FF00_C                      (* (0xFF00+C) *)        [@printer fun fmt _ -> fprintf fmt "(0xFF00+C)"]
  | SP                          (* SP *)                [@printer fun fmt _ -> fprintf fmt "SP"]
  | SP_offset of uint8          (* SP+0x9A *)           [@printer fun fmt x -> fprintf fmt "SP+%s" (show_uint8 x)]
  | HL_inc                      (* (HL+) *)             [@printer fun fmt _ -> fprintf fmt "(HL+)"]
  | HL_dec                      (* (HL-) *)             [@printer fun fmt _ -> fprintf fmt "(HL-)"]
[@@deriving show]

type load_operand = load_term * load_term
                    [@printer fun fmt (l, r) -> fprintf fmt "%s, %s" (show_load_term l) (show_load_term r)]
[@@deriving show]

type alu_operand =
  | Immediate of uint8      [@printer pp_uint8]
  | R_direct of Registers.r [@printer Registers.pp_r]
  | HL_indirect             [@printer fun fmt _ -> fprintf fmt "(HL)"]
[@@deriving show]

type to_hl =
  | RR_direct of Registers.rr [@printer Registers.pp_rr]
  | SP                        [@printer fun fmt _ -> fprintf fmt "SP"]
[@@deriving show]

type add_operand =
  | To_A of alu_operand [@printer fun fmt x -> fprintf fmt "A, %s" (show_alu_operand x)]
  | To_HL of to_hl      [@printer fun fmt x -> fprintf fmt "HL, %s" (show_to_hl x)]
  | To_SP of uint8      [@printer fun fmt x -> fprintf fmt "SP, %s" (show_uint8 x)]
[@@deriving show]

type inc_operand =
  | R_direct of Registers.r   [@printer Registers.pp_r]
  | RR_direct of Registers.rr [@printer Registers.pp_rr]
  | HL_indirect               [@printer fun fmt _ -> fprintf fmt "(HL)"]
  | SP                        [@printer fun fmt _ -> fprintf fmt "SP"]
[@@deriving show]

type dec_operand = inc_operand
[@@deriving show]

type r_operand =
  | R_direct of Registers.r [@printer Registers.pp_r]
  | HL_indirect             [@printer fun fmt _ -> fprintf fmt "(HL)"]
[@@deriving show]

type rr_operand =
  | RR_direct of Registers.rr [@printer Registers.pp_rr]
[@@deriving show]

type condition =
  | NZ [@printer fun fmt _ -> fprintf fmt "NZ"]
  | Z  [@printer fun fmt _ -> fprintf fmt "Z"]
  | NC [@printer fun fmt _ -> fprintf fmt "NC"]
  | C  [@printer fun fmt _ -> fprintf fmt "C"]
[@@deriving show]

type jp_operand =
  | No_cond of uint16          [@printer pp_uint16]
  | Cond of condition * uint16 [@printer fun fmt (c, x) -> fprintf fmt "%s, %s" (show_condition c) (show_uint16 x)]
  | HL_indirect                [@printer fun fmt _ -> fprintf fmt "(HL)"]
[@@deriving show]

type jr_operand =
  | No_cond of uint8          [@printer pp_uint8]
  | Cond of condition * uint8 [@printer fun fmt (c, x) -> fprintf fmt "%s, %s" (show_condition c) (show_uint8 x)]
[@@deriving show]

type call_operand =
  | No_cond of uint16          [@printer pp_uint16]
  | Cond of condition * uint16 [@printer fun fmt (c, x) -> fprintf fmt "%s, %s" (show_condition c) (show_uint16 x)]
[@@deriving show]

type ret_operand =
  | No_cond           [@printer fun fmt _ -> fprintf fmt ""]
  | Cond of condition [@printer pp_condition]
[@@deriving show]

type t =
  | LD of load_operand       [@printer fun fmt x -> fprintf fmt "LD %s" (show_load_operand x)]
  | PUSH of rr_operand       [@printer fun fmt x -> fprintf fmt "PUSH %s" (show_rr_operand x)]
  | POP of rr_operand        [@printer fun fmt x -> fprintf fmt "POP %s" (show_rr_operand x)]
  | ADD of add_operand       [@printer fun fmt x -> fprintf fmt "ADD %s" (show_add_operand x)]
  | ADC of alu_operand       [@printer fun fmt x -> fprintf fmt "ADC A, %s" (show_alu_operand x)]
  | SUB of alu_operand       [@printer fun fmt x -> fprintf fmt "SUB A, %s" (show_alu_operand x)]
  | SBC of alu_operand       [@printer fun fmt x -> fprintf fmt "SBC A, %s" (show_alu_operand x)]
  | AND of alu_operand       [@printer fun fmt x -> fprintf fmt "AND A, %s" (show_alu_operand x)]
  | OR of alu_operand        [@printer fun fmt x -> fprintf fmt "OR A, %s" (show_alu_operand x)]
  | XOR of alu_operand       [@printer fun fmt x -> fprintf fmt "XOR A, %s" (show_alu_operand x)]
  | CP of alu_operand        [@printer fun fmt x -> fprintf fmt "CP A, %s" (show_alu_operand x)]
  | INC of inc_operand       [@printer fun fmt x -> fprintf fmt "INC %s" (show_inc_operand x)]
  | DEC of dec_operand       [@printer fun fmt x -> fprintf fmt "DEC %s" (show_dec_operand x)]
  | SWAP of r_operand        [@printer fun fmt x -> fprintf fmt "SWAP %s" (show_r_operand x)]
  | DAA                      [@printer fun fmt _ -> fprintf fmt "DAA"]
  | CPL                      [@printer fun fmt _ -> fprintf fmt "CPL"]
  | CCF                      [@printer fun fmt _ -> fprintf fmt "CCF"]
  | SCF                      [@printer fun fmt _ -> fprintf fmt "SCF"]
  | NOP                      [@printer fun fmt _ -> fprintf fmt "NOP"]
  | HALT                     [@printer fun fmt _ -> fprintf fmt "HALT"]
  | STOP                     [@printer fun fmt _ -> fprintf fmt "STOP"]
  | DI                       [@printer fun fmt _ -> fprintf fmt "DI"]
  | EI                       [@printer fun fmt _ -> fprintf fmt "EI"]
  | RLCA                     [@printer fun fmt _ -> fprintf fmt "RLCA"]
  | RLA                      [@printer fun fmt _ -> fprintf fmt "RLA"]
  | RRCA                     [@printer fun fmt _ -> fprintf fmt "RRCA"]
  | RRA                      [@printer fun fmt _ -> fprintf fmt "RRA"]
  | RLC of r_operand         [@printer fun fmt x -> fprintf fmt "RLC %s" (show_r_operand x)]
  | RL of r_operand          [@printer fun fmt x -> fprintf fmt "RL %s" (show_r_operand x)]
  | RRC of r_operand         [@printer fun fmt x -> fprintf fmt "RRC %s" (show_r_operand x)]
  | RR of r_operand          [@printer fun fmt x -> fprintf fmt "RR %s" (show_r_operand x)]
  | SLA of r_operand         [@printer fun fmt x -> fprintf fmt "SLA %s" (show_r_operand x)]
  | SRA of r_operand         [@printer fun fmt x -> fprintf fmt "SRA %s" (show_r_operand x)]
  | SRL of r_operand         [@printer fun fmt x -> fprintf fmt "SRL %s" (show_r_operand x)]
  | BIT of uint8 * r_operand [@printer fun fmt (n, x) -> fprintf fmt "BIT %s, %s" (show_uint8 n) (show_r_operand x)]
  | SET of uint8 * r_operand [@printer fun fmt (n, x) -> fprintf fmt "SET %s, %s" (show_uint8 n) (show_r_operand x)]
  | RES of uint8 * r_operand [@printer fun fmt (n, x) -> fprintf fmt "RES %s, %s" (show_uint8 n) (show_r_operand x)]
  | JP of jp_operand         [@printer fun fmt x -> fprintf fmt "JP %s" (show_jp_operand x)]
  | JR of jr_operand         [@printer fun fmt x -> fprintf fmt "JR %s" (show_jr_operand x)]
  | CALL of call_operand     [@printer fun fmt x -> fprintf fmt "CALL %s" (show_call_operand x)]
  | RST of uint16            [@printer fun fmt x -> fprintf fmt "RST %s" (show_uint16 x)]
  | RET of ret_operand       [@printer fun fmt x -> fprintf fmt "RET %s" (show_ret_operand x)]
  | RETI                     [@printer fun fmt _ -> fprintf fmt "RETI"]
[@@deriving show]
