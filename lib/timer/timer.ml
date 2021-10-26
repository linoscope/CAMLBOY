(* Ref: https://hacktixme.ga/GBEDG/timers/ *)

open Uints

type t = {
  div_addr : uint16;
  tima_addr : uint16;
  tma_addr : uint16;
  tac_addr : uint16;
  ic : Interrupt_controller.t;
  mutable internal_tcycle_count : uint16;
  mutable tima : uint8;
  mutable tma : uint8;
  mutable tac : uint8;
  mutable reload_tima_on_next_mcycle : bool;
}

let create ~div_addr ~tima_addr ~tma_addr ~tac_addr ~ic = {
  div_addr;
  tima_addr;
  tma_addr;
  tac_addr;
  ic;
  internal_tcycle_count = Uint16.zero;
  tima = Uint8.zero;
  tma = Uint8.zero;
  tac = Uint8.zero;
  reload_tima_on_next_mcycle = false;
}

(** Takes old and new value of [internal_tcycle_count] and detects if it has a "falling edge"
 ** You can read more on "falling edge" here: https://hacktixme.ga/GBEDG/timers/ *)
let has_falling_edge t old new_ =
  let old = Uint16.to_int old in
  let new_ = Uint16.to_int new_ in
  let bit_to_check =
    let tac = (t.tac |> Uint8.to_int) land 0b11 in
    match tac with
    | 0b00 -> 9
    | 0b01 -> 3
    | 0b10 -> 5
    | 0b11 -> 7
    | _ -> assert false
  in
  let mask = 1 lsl bit_to_check in
  (old land mask <> 0) && (new_ land mask = 0)

let run t ~mcycles =
  let is_tima_enabled = Uint8.(t.tac land of_int 0b100 <> zero) in
  for _ = 0 to mcycles - 1 do
    if t.reload_tima_on_next_mcycle then begin
      t.reload_tima_on_next_mcycle <- false;
      t.tima <- t.tma;
      Interrupt_controller.request t.ic Timer;
    end;
    let old = t.internal_tcycle_count in
    t.internal_tcycle_count <- Uint16.(t.internal_tcycle_count + of_int 4);
    let new_ = t.internal_tcycle_count in
    if is_tima_enabled then
      if has_falling_edge t old new_ then begin
        t.tima <- Uint8.succ t.tima;
        if Uint8.(t.tima = zero) then
          (* Quote from https://hacktixme.ga/GBEDG/timers/ *)
          (*  After overflowing the TIMA register contains
           *  a zero value for a duration of 4 T-cycles.
           *  Only after these have elapsed it is reloaded with the value of TMA at $FF06,
           *  and only then a Timer Interrupt is requested. *)
          t.reload_tima_on_next_mcycle <- true
      end
  done

let accepts t addr =
  addr = t.div_addr || addr = t.tima_addr || addr = t.tma_addr || addr = t.tac_addr

let read_byte t addr =
  let open Uint16 in
  match addr with
  | _ when addr = t.div_addr ->
    (* DIV is incremented every 2^8 = 256 tcycles *)
    t. internal_tcycle_count lsr 8 |> Uint16.to_uint8
  | _ when addr = t.tima_addr ->
    t.tima
  | _ when addr = t.tma_addr ->
    t.tma
  | _ when addr = t.tac_addr ->
    t.tac
  | _ -> assert false

let write_byte t ~addr ~data =
  let open Uint16 in
  match addr with
  | _ when addr = t.div_addr ->
    if has_falling_edge t t.internal_tcycle_count Uint16.zero then
      t.tima <- Uint8.succ t.tima;
    t.internal_tcycle_count <- Uint16.zero;
  | _ when addr = t.tima_addr ->
    t.tima <- data
  | _ when addr = t.tma_addr ->
    t.tma <- data
  | _ when addr = t.tac_addr ->
    t.tac <- data
  | _ -> assert false

module For_tests = struct
  let get_tima_count t = t.tima
end
