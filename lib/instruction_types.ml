open Ints

type load_term =
  | Immediate8 of uint8         (* Ex. 0x9A *)
  | Immediate16 of uint16       (* Ex. 0x9ABC *)
  | R_direct of Registers.r     (* Ex. A *)
  | RR_direct of Registers.rr   (* Ex. BC *)
  | RR_indirect of Registers.rr (* Ex. (BC) *)
  | Direct of uint16            (* Ex. (0x9ABC) *)
  | FF00_offset of uint8        (* Ex. (0xFF00+0x10) *)
  | FF00_C
  | SP                          (* SP *)
  | HL_inc                      (* (HL+) *)
  | HL_dec                      (* (HL-) *)

type load_operand = load_term * load_term

type alu_operand =
  | Immediate of uint8      (* Ex. 0x9A *)
  | R_direct of Registers.r (* Ex. A *)
  | HL_indirect             (* Ex. (HL) *)

type to_hl =
  | RR_direct of Registers.rr
  | SP

type add_operand =
  | To_A of alu_operand
  | To_HL of to_hl
  | To_SP of uint8

type inc_operand =
  | R_direct of Registers.r     (* Ex. A *)
  | RR_direct of Registers.rr   (* Ex. BC *)
  | HL_indirect                 (* (HL) *)
  | SP

type dec_operand = inc_operand

type r_operand =
  | R_direct of Registers.r (* Ex. A *)
  | HL_indirect             (* (HL) *)

type rr_operand =
  | RR_direct of Registers.rr

type condition = NZ | Z | NC | C

type jp_operand =
  | No_cond of uint16
  | Cond of condition * uint16
  | HL_indirect

type jr_operand =
  | No_cond of uint8
  | Cond of condition * uint8

type call_operand =
  | No_cond of uint16
  | Cond of condition * uint16

type ret_operand =
  | No_cond
  | Cond of condition

type t =
  | LD of load_operand
  | PUSH of rr_operand
  | POP of rr_operand
  | ADD of add_operand
  | ADC of alu_operand
  | SUB of alu_operand
  | SBC of alu_operand
  | AND of alu_operand
  | OR of alu_operand
  | XOR of alu_operand
  | CP of alu_operand
  | INC of inc_operand
  | DEC of dec_operand
  | SWAP of r_operand
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
  | RLC of r_operand
  | RL of r_operand
  | RRC of r_operand
  | RR of r_operand
  | SLA of r_operand
  | SRA of r_operand
  | SRL of r_operand
  | BIT of uint8 * r_operand
  | SET of uint8 * r_operand
  | RES of uint8 * r_operand
  | JP of jp_operand
  | JR of jr_operand
  | CALL of call_operand
  | RST of uint16
  | RET of ret_operand
  | RETI
