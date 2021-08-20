open Uints

include Instruction_types

let show = function
  | LD (x, y)    -> Printf.sprintf "LD %s, %s" (show_arg x) (show_arg y)
  | LD16 (x, y)  -> Printf.sprintf "LD %s, %s" (show_arg16 x) (show_arg16 y)
  | ADD (x, y)   -> Printf.sprintf "ADD %s, %s" (show_arg x) (show_arg y)
  | ADD16 (x, y) -> Printf.sprintf "ADD %s, %s" (show_arg16 x) (show_arg16 y)
  | ADC (x, y)   -> Printf.sprintf "ADC %s, %s" (show_arg x) (show_arg y)
  | SUB (x, y)   -> Printf.sprintf "SUB %s, %s" (show_arg x) (show_arg y)
  | SBC (x, y)   -> Printf.sprintf "SBC %s, %s" (show_arg x) (show_arg y)
  | AND (x, y)   -> Printf.sprintf "AND %s, %s" (show_arg x) (show_arg y)
  | OR (x, y)    -> Printf.sprintf "OR %s, %s" (show_arg x) (show_arg y)
  | XOR (x, y)   -> Printf.sprintf "XOR %s, %s" (show_arg x) (show_arg y)
  | CP (x, y)    -> Printf.sprintf "CP %s, %s" (show_arg x) (show_arg y)
  | INC x        -> Printf.sprintf "INC %s" (show_arg x)
  | INC16 x      -> Printf.sprintf "INC %s" (show_arg16 x)
  | DEC x        -> Printf.sprintf "DEC %s" (show_arg x)
  | DEC16 x      -> Printf.sprintf "DEC %s" (show_arg16 x)
  | SWAP x       -> Printf.sprintf "SWAP %s" (show_arg x)
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
  | PUSH rr      -> Printf.sprintf "PUSH %s" (Registers.show_rr rr)
  | POP rr       -> Printf.sprintf "POP %s" (Registers.show_rr rr)
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
