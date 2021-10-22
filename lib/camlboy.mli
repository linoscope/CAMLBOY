open Uints

module Make (Cartridge : Cartridge_intf.S) : sig

  type t [@@deriving show]

  val create_with_rom : print_serial_port:bool -> rom_bytes:bytes -> t

  val run_instruction : t -> Gpu.run_result

  val press : t -> Joypad.key -> unit

  val release : t -> Joypad.key -> unit

  module For_tests : sig

    val prev_inst : t -> Instruction.t

    val get_ly : t -> int

    val get_lcd_stat : t -> uint8

    val get_mcycles_in_mode : t -> int

    val get_tima_count : t -> uint8
  end

end
