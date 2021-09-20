(** LCD Status Register
 ** @see <https://gbdev.io/pandocs/STAT.html>  *)
(* Bit 6 - LYC=LY STAT Interrupt source         (1=Enable) (Read/Write)
 * Bit 5 - Mode 2 OAM STAT Interrupt source     (1=Enable) (Read/Write)
 * Bit 4 - Mode 1 VBlank STAT Interrupt source  (1=Enable) (Read/Write)
 * Bit 3 - Mode 0 HBlank STAT Interrupt source  (1=Enable) (Read/Write)
 * Bit 2 - LYC=LY Flag                          (0=Different, 1=Equal) (Read Only)
 * Bit 1-0 - Mode Flag                          (Mode 0-3, see below) (Read Only)
 *           0: HBlank
 *           1: VBlank
 *           2: Searching OAM
 *           3: Transferring Data to LCD Controller *)

open Uints

type t

type stat_interupt_source =
  | LYC_eq_LY
  | OAM
  | VBlank
  | HBlank

val create : addr:uint16 -> t

val is_enabled : t -> stat_interupt_source -> bool

val get_lyc_eq_ly_flag : t -> bool

val set_lyc_eq_ly_flag : t -> bool -> unit

val get_gpu_mode : t -> Gpu_mode.t

val set_gpu_mode : t -> Gpu_mode.t -> unit

include Addressable_intf.S with type t := t
