(* Ref: https://hacktixme.ga/GBEDG/timers/ *)
open Uints

type frequency =
  | F_4096Hz
  | F_262144Hz
  | F_65536Hz
  | F_16384Hz

type t = {
  div_addr  : uint16;
  tima_addr : uint16;
  tma_addr  : uint16;
  tac_addr  : uint16;
  ic        : Interrupt_controller.t;
  mutable internal_mcycle_count : uint16;
  mutable div_counter           : uint8;
  mutable tima_enabled          : bool;
  mutable tima_frequency        : frequency;
  mutable tima_tma              : uint8;
  mutable tima_counter          : uint8;
}

let create ~div_addr ~tima_addr ~tma_addr ~tac_addr ~ic = {
  div_addr;
  tima_addr;
  tma_addr;
  tac_addr;
  ic;
  internal_mcycle_count = Uint16.zero;
  div_counter           = Uint8.zero;
  tima_enabled          = false;
  tima_frequency        = F_4096Hz;
  tima_counter          = Uint8.zero;
  tima_tma              = Uint8.zero;
}

let quotient_diff modulo before after =
  let open Uint16 in
  let divider = of_int modulo in
  (after / divider - before / divider) |> to_uint8
let quotient_diff256 = quotient_diff 256
let quotient_diff64  = quotient_diff 64
let quotient_diff16  = quotient_diff 16
let quotient_diff4   = quotient_diff 4
let quotient_diff_of_frequency = function
  | F_4096Hz   -> quotient_diff256
  | F_262144Hz -> quotient_diff4
  | F_65536Hz  -> quotient_diff16
  | F_16384Hz  -> quotient_diff64

let run t ~mcycles =
  let before_mcycle_count = t.internal_mcycle_count in
  t.internal_mcycle_count <- Uint16.(t.internal_mcycle_count + of_int mcycles);
  let after_mcycle_count = t.internal_mcycle_count in
  t.div_counter <- Uint8.(t.div_counter + quotient_diff64 before_mcycle_count after_mcycle_count);
  if t.tima_enabled then begin
    let quotient_diff = quotient_diff_of_frequency t.tima_frequency in
    let before_tima_counter = t.tima_counter in
    t.tima_counter <- Uint8.(t.tima_counter + quotient_diff before_mcycle_count after_mcycle_count);
    let after_tima_counter = t.tima_counter in
    if (after_tima_counter < before_tima_counter) then begin
      Interrupt_controller.request t.ic Timer;
      t.tima_counter <- t.tima_tma;
    end
  end
;;

let accepts t addr =
  addr = t.div_addr || addr = t.tima_addr || addr = t.tma_addr || addr = t.tac_addr

let read_byte t addr =
  let byte_of_frequency = function
    | F_4096Hz   -> Uint8.of_int 0b00
    | F_262144Hz -> Uint8.of_int 0b01
    | F_65536Hz  -> Uint8.of_int 0b10
    | F_16384Hz  -> Uint8.of_int 0b11
  in
  match addr with
  | _ when addr = t.div_addr ->
    t.div_counter
  | _ when addr = t.tima_addr ->
    t.tima_counter
  | _ when addr = t.tma_addr ->
    t.tima_tma
  | _ when addr = t.tac_addr ->
    let enable_bit = (if t.tima_enabled then 0b100 else 0b000) |> Uint8.of_int in
    Uint8.(enable_bit land byte_of_frequency t.tima_frequency)
  | _ -> assert false

let write_byte t ~addr ~data =
  let frequency_of_byte byte =
    let byte = Uint8.to_int byte in
    match byte land 0b11 with
    | 0b00 -> F_4096Hz
    | 0b01 -> F_262144Hz
    | 0b10 -> F_65536Hz
    | 0b11 -> F_16384Hz
    | _ -> assert false
  in
  match addr with
  | _ when addr = t.div_addr ->
    t.div_counter <- Uint8.zero;
    t.internal_mcycle_count <- Uint16.zero;
  | _ when addr = t.tima_addr ->
    t.tima_counter <- data
  | _ when addr = t.tma_addr ->
    t.tima_tma <- data
  | _ when addr = t.tac_addr ->
    if Uint8.(data land of_int 0b100 <> Uint8.zero) then
      t.tima_enabled <- true;
    t.tima_frequency <- frequency_of_byte data
  | _ -> assert false

module For_tests = struct
  let get_tima_count t = t.tima_counter
end
