(* Audio Mixer - combines channel outputs into stereo samples.

   NR51 controls panning:
   - Bits 0-3: Channels 1-4 to right output
   - Bits 4-7: Channels 1-4 to left output

   NR50 controls volume:
   - Bits 0-2: Right volume (0-7)
   - Bits 4-6: Left volume (0-7) *)

open Uints

module type SQUARE_SAMPLER = sig
  val get_sample : Square_channel.t -> sample_rate:int -> float
end

module type S = sig
  val mix :
    square1:Square_channel.t ->
    square2:Square_channel.t ->
    wave:Wave_channel.t ->
    noise:Noise_channel.t ->
    nr50:uint8 ->
    nr51:uint8 ->
    sample_rate:int ->
    int * int
end

(* Band-limited synthesis for square channels *)
module Square_blep = Blep.Make (Square_channel)

module Make (S : SQUARE_SAMPLER) = struct
  let mix ~square1 ~square2 ~wave ~noise ~nr50 ~nr51 ~sample_rate =
    let s1 = S.get_sample square1 ~sample_rate in
    let s2 = S.get_sample square2 ~sample_rate in
    (* Wave/noise: convert 0-15 to 0.0-1.0 *)
    let s3 = float_of_int (Wave_channel.get_sample wave) /. 15.0 in
    let s4 = float_of_int (Noise_channel.get_sample noise) /. 15.0 in

    let nr51 = Uint8.to_int nr51 in
    let nr50 = Uint8.to_int nr50 in

    let left =
      (if nr51 land 0x10 <> 0 then s1 else 0.0) +.
      (if nr51 land 0x20 <> 0 then s2 else 0.0) +.
      (if nr51 land 0x40 <> 0 then s3 else 0.0) +.
      (if nr51 land 0x80 <> 0 then s4 else 0.0)
    in
    let right =
      (if nr51 land 0x01 <> 0 then s1 else 0.0) +.
      (if nr51 land 0x02 <> 0 then s2 else 0.0) +.
      (if nr51 land 0x04 <> 0 then s3 else 0.0) +.
      (if nr51 land 0x08 <> 0 then s4 else 0.0)
    in

    let vol_left = float_of_int (((nr50 lsr 4) land 0x07) + 1) in
    let vol_right = float_of_int ((nr50 land 0x07) + 1) in
    (* Scale to int16: 4 channels * 1.0 * 8 = 32 max -> ~1024 to reach 32767 *)
    let scale = 1024.0 in
    let left_out = int_of_float (left *. vol_left *. scale) in
    let right_out = int_of_float (right *. vol_right *. scale) in

    let clamp v = max (-32768) (min 32767 v) in
    (clamp left_out, clamp right_out)
end

(* Naive sampler: direct hardware output, may have aliasing *)
module Naive_sampler = struct
  let get_sample ch ~sample_rate:_ =
    if not (Square_channel.is_active ch) then 0.0
    else
      let raw = float_of_int (Square_channel.output ch) in
      let vol = float_of_int (Square_channel.volume ch) /. 15.0 in
      (raw *. 2.0 -. 1.0) *. vol
end

(* BLEP sampler: band-limited, no aliasing *)
module Blep_sampler = struct
  let get_sample = Square_blep.get_sample
end

module Naive = Make (Naive_sampler)
module Blep = Make (Blep_sampler)
