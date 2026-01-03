(* Audio Processing Unit (APU) implementation.
   Reference: https://gbdev.gg8.se/wiki/articles/Gameboy_sound_hardware *)

open Uints

(* APU register addresses *)
let nr10_addr = 0xFF10  (* Square 1 sweep *)
let nr52_addr = 0xFF26  (* Sound on/off *)
let wave_ram_start = 0xFF30
let wave_ram_end = 0xFF3F

type t = {
  (* Channel registers: NR10-NR14, NR21-NR24, NR30-NR34, NR41-NR44 *)
  (* For now, store raw register values *)
  regs : uint8 array;  (* 0xFF10-0xFF26, indexed as addr - 0xFF10 *)

  (* Wave RAM: 16 bytes = 32 4-bit samples *)
  wave_ram : uint8 array;

  (* Master control state extracted from NR52 *)
  mutable power_on : bool;
}

let create () = {
  regs = Array.make 23 Uint8.zero;  (* 0xFF10 to 0xFF26 inclusive *)
  wave_ram = Array.make 16 Uint8.zero;
  power_on = false;
}

let run _t ~mcycles:_ =
  (* No-op for now - will be implemented in later patches *)
  ()

let accepts _t addr =
  let a = Uint16.to_int addr in
  (* NR10-NR26: 0xFF10-0xFF26 *)
  (* Wave RAM: 0xFF30-0xFF3F *)
  (a >= nr10_addr && a <= nr52_addr) || (a >= wave_ram_start && a <= wave_ram_end)

let read_byte t addr =
  let a = Uint16.to_int addr in
  if a >= wave_ram_start && a <= wave_ram_end then
    (* Wave RAM *)
    t.wave_ram.(a - wave_ram_start)
  else if a >= nr10_addr && a <= nr52_addr then begin
    (* Sound registers *)
    let reg_idx = a - nr10_addr in
    if a = nr52_addr then
      (* NR52: bit 7 is power, bits 0-3 are channel status (read-only) *)
      (* For now, just return power bit + unused bits set *)
      let power_bit = if t.power_on then 0x80 else 0x00 in
      Uint8.of_int (0x70 lor power_bit)
    else
      (* Other registers: return stored value OR'd with read mask *)
      (* Read masks will be implemented in a later patch *)
      t.regs.(reg_idx)
  end else
    Uint8.of_int 0xFF

let write_byte t ~addr ~data =
  let a = Uint16.to_int addr in
  if a >= wave_ram_start && a <= wave_ram_end then
    (* Wave RAM write *)
    t.wave_ram.(a - wave_ram_start) <- data
  else if a >= nr10_addr && a <= nr52_addr then begin
    let reg_idx = a - nr10_addr in
    if a = nr52_addr then begin
      (* NR52: only bit 7 (power) is writable *)
      let new_power = Uint8.to_int data land 0x80 <> 0 in
      if t.power_on && not new_power then begin
        (* Power off: clear all registers except NR52 and wave RAM *)
        for i = 0 to 21 do
          t.regs.(i) <- Uint8.zero
        done
      end;
      t.power_on <- new_power
    end else if t.power_on then
      (* Only allow writes when powered on *)
      t.regs.(reg_idx) <- data
    (* When powered off, writes to registers (except NR52) are ignored *)
  end
