open Uints

module Speed : sig
  type t
  val of_byte : uint8 -> t
  val to_byte : t -> uint8
  val mcycle_per_count : t -> int
end = struct
  type t = int (* cpu mclock / timer mclock *)

  (* cpu mclock: 1048576 Hz
   * timer mclock:
   * - 00:   4096 Hz => cpu mclock / timer mclock = 256
   * - 01: 262144 Hz => cpu mclock / timer mclock = 4
   * - 10:  65536 Hz => cpu mclock / timer mclock = 16
   * - 11:  16384 Hz => cpu mclock / timer mclock = 64
   *  *)
  let of_byte u8 =
    let open Uint8 in
    let u8 = of_int 0b00000011 land u8 in
    if u8 = of_int 0b00 then
      256
    else if u8 = of_int 0b01 then
      4
    else if u8 = of_int 0b10 then
      16
    else if u8 = of_int 0b11 then
      64
    else
      assert false

  let to_byte t = t |> Uint8.of_int

  external mcycle_per_count : t -> int = "%identity"
end

type t = {
  tima_addr : uint16;
  tma_addr : uint16;
  tac_addr : uint16;
  ic : Interrupt_controller.t;
  mutable count : int;
  mutable uncounted_mcycles : int;
  mutable modulo : int;
  mutable is_running : bool;
  mutable speed : Speed.t;
}

let create ~tima_addr ~tma_addr ~tac_addr ~ic = {
  tima_addr;
  tma_addr;
  tac_addr;
  ic;
  count = 0;
  uncounted_mcycles = 0;
  modulo = 0;
  is_running = true;
  speed = Speed.of_byte Uint8.zero;
}

let run t ~mcycles =
  if t.is_running then begin
    t.uncounted_mcycles <- t.uncounted_mcycles + mcycles;
    let mcycle_per_count = Speed.mcycle_per_count t.speed in
    if t.uncounted_mcycles >= mcycle_per_count then begin
      t.count <- t.count + (t.uncounted_mcycles / mcycle_per_count);
      t.uncounted_mcycles <- t.uncounted_mcycles mod mcycle_per_count;
      if t.count > 0xFF then begin
        Interrupt_controller.request t.ic Timer;
        t.count <- t.modulo
      end
    end
  end

let accepts t addr =
  Uint16.(addr = t.tima_addr || addr = t.tma_addr || addr = t.tac_addr)

let read_byte t addr =
  match addr with
  | _ when Uint16.(addr = t.tima_addr) ->
    t.count |> Uint8.of_int
  | _ when Uint16.(addr = t.tma_addr)  -> t.modulo |> Uint8.of_int
  | _ when Uint16.(addr = t.tac_addr)  ->
    let open Uint8 in
    let running_bits = if t.is_running then of_int 0b100 else of_int 0b000 in
    let speed_bits = Speed.to_byte t.speed in
    running_bits land speed_bits land of_int 0b11111000
  | _ -> raise @@ Invalid_argument "Address out of bounds"

let write_byte t ~addr ~data =
  match addr with
  | _ when Uint16.(addr = t.tima_addr) -> t.count <- Uint8.to_int data
  | _ when Uint16.(addr = t.tma_addr)  -> t.modulo <- Uint8.to_int data
  | _ when Uint16.(addr = t.tac_addr)  ->
    t.speed <- Speed.of_byte data;
    t.is_running <- Uint8.(data land of_int 0b100 <> zero);
    if not t.is_running then
      t.uncounted_mcycles <- 0
  | _ -> raise @@ Invalid_argument "Address out of bounds"
