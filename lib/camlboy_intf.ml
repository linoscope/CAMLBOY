open Uints

module type S = sig
  type t

  val show : t -> string

  val create_with_rom :
    ?use_blep:bool ->
    print_serial_port:bool ->
    rom_bytes:Bigstringaf.t ->
    unit ->
    t

  val run_instruction : t -> Gpu.run_result

  val press : t -> Joypad.key -> unit

  val release : t -> Joypad.key -> unit

  (** Get the APU for audio output access *)
  val get_apu : t -> Apu.t

  module For_tests : sig
    val prev_inst : t -> Instruction.t

    val get_ly : t -> int

    val get_lcd_stat : t -> uint8

    val get_mcycles_in_mode : t -> int

    val get_tima_count : t -> uint8
  end
end
