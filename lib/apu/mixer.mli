(** Audio Mixer - combines channel outputs into stereo samples.

    The mixer handles:
    - Channel panning (NR51 register)
    - Master volume (NR50 register)
    - Scaling to int16 output range

    Two implementations are provided:
    - {!Naive}: Direct hardware sampling (may have aliasing)
    - {!Blep}: Band-limited synthesis (no aliasing) *)

open Uints

(** {2 Square Channel Sampling}

    The mixer is parameterized by how square channels are sampled.
    This allows switching between naive (aliased) and band-limited output. *)

module type SQUARE_SAMPLER = sig
  (** Get sample value in range [-1.0, 1.0] with volume applied *)
  val get_sample : Square_channel.t -> sample_rate:int -> float
end

(** {2 Pre-built Samplers} *)

(** Naive sampler: direct hardware output, may have aliasing *)
module Naive_sampler : SQUARE_SAMPLER

(** BLEP sampler: band-limited synthesis, no aliasing *)
module Blep_sampler : SQUARE_SAMPLER

(** {2 Mixer Signature} *)

module type S = sig
  (** Mix all channels into a stereo sample.
      @return (left, right) tuple of int16 samples *)
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

(** {2 Mixer Functor} *)

(** Create a mixer with a custom square channel sampler. *)
module Make (_ : SQUARE_SAMPLER) : S

(** {2 Pre-built Mixers} *)

(** Naive mixer: uses direct hardware sampling *)
module Naive : S

(** BLEP mixer: uses band-limited synthesis *)
module Blep : S
