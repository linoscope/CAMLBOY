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
  mutable internal_mcycle_count : int;
  mutable div_counter           : int;
  mutable tima_enabled          : bool;
  mutable tima_frequency        : frequency;
  mutable tima_tma              : int;
  mutable tima_counter          : int;
}

let create ~div_addr ~tima_addr ~tma_addr ~tac_addr ~ic = {
  div_addr;
  tima_addr;
  tma_addr;
  tac_addr;
  ic;
  internal_mcycle_count = 0;
  div_counter           = 0;
  tima_enabled          = false;
  tima_frequency        = F_4096Hz;
  tima_counter          = 0;
  tima_tma              = 0;
}

let run t ~mcycles =
  let before_mcycle_count = t.internal_mcycle_count in
  let after_mcycle_count = before_mcycle_count + mcycles in
  t.internal_mcycle_count <- after_mcycle_count mod 0x10000;
  let quotient_diff = (after_mcycle_count / 64 - before_mcycle_count / 64) in
  t.div_counter <- (t.div_counter + quotient_diff) mod 0x100;
  if t.tima_enabled then begin
    let divider = match t.tima_frequency with
      | F_4096Hz   -> 256
      | F_262144Hz -> 4
      | F_65536Hz  -> 16
      | F_16384Hz  -> 64
    in
    let quotient_diff = (after_mcycle_count / divider - before_mcycle_count / divider) in
    let before_tima_counter = t.tima_counter in
    t.tima_counter <- (t.tima_counter + quotient_diff) mod 0x100;
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
    t.div_counter |> Uint8.of_int
  | _ when addr = t.tima_addr ->
    t.tima_counter |> Uint8.of_int
  | _ when addr = t.tma_addr ->
    t.tima_tma |> Uint8.of_int
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
    t.div_counter <- 0;
    t.internal_mcycle_count <- 0;
  | _ when addr = t.tima_addr ->
    t.tima_counter <- (Uint8.to_int data)
  | _ when addr = t.tma_addr ->
    t.tima_tma <- (Uint8.to_int data)
  | _ when addr = t.tac_addr ->
    if Uint8.(data land of_int 0b100 <> Uint8.zero) then
      t.tima_enabled <- true;
    t.tima_frequency <- frequency_of_byte data
  | _ -> assert false

module For_tests = struct
  let get_tima_count t = t.tima_counter |> Uint8.of_int
end
