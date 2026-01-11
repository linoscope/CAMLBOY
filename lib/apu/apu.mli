(** Audio Processing Unit (APU) for Game Boy sound emulation.

    The APU handles four sound channels:
    - Square 1: Pulse wave with frequency sweep
    - Square 2: Pulse wave
    - Wave: Custom 32-sample waveform
    - Noise: LFSR-based pseudo-random noise

    Memory-mapped registers: 0xFF10-0xFF26, 0xFF30-0xFF3F (wave RAM)

    Audio output is accumulated in an internal ring buffer at the specified
    sample rate. The SDL2 frontend pulls samples via callback. *)

open Uints

type t

(** Create a new APU instance.
    @param sample_rate Audio sample rate in Hz (default: 44100)
    @param sec_per_frame Expected frame duration in seconds (default: 1/60)
    @param buffer_size Audio buffer capacity in samples.
      Default: 2 * samples_per_frame, which provides enough headroom
      for audio-driven emulation where the audio callback requests
      samples_per_frame samples and the emulator generates one video
      frame worth of audio per callback.
    @param use_blep Enable band-limited synthesis (polyBLEP) for square
      channels to prevent aliasing. Default: true. *)
val create :
  ?sample_rate:int ->
  ?sec_per_frame:float ->
  ?buffer_size:int ->
  ?use_blep:bool ->
  unit -> t

(** Advance APU state by the given number of M-cycles.
    This updates the frame sequencer, all channels, and generates audio samples. *)
val run : t -> mcycles:int -> unit

(** Check if the APU handles the given address. *)
val accepts : t -> uint16 -> bool

(** Read a byte from an APU register. *)
val read_byte : t -> uint16 -> uint8

(** Write a byte to an APU register. *)
val write_byte : t -> addr:uint16 -> data:uint8 -> unit

(** {2 Audio Buffer Access}

    These functions provide access to the audio buffer for the SDL2 callback. *)

(** Get the internal audio buffer (for direct access). *)
val get_audio_buffer : t -> Audio_buffer.t

(** Get number of samples available in the buffer. *)
val samples_available : t -> int

(** Pop a single stereo sample from the buffer.
    Returns None if buffer is empty. *)
val pop_sample : t -> Audio_buffer.sample option

(** Pop multiple samples into bigarray. Returns number of samples read.
    This is the main interface for the SDL2 audio callback.
    Destination should be interleaved stereo (L R L R ...).
    @param dst Bigarray to fill with interleaved stereo samples
    @param count Maximum number of samples to read *)
val pop_samples : t -> dst:Audio_buffer.ba -> count:int -> int

(** Get the audio buffer capacity (maximum number of samples it can hold). *)
val buffer_capacity : t -> int

(** Get the sample rate associated with this APU. *)
val sample_rate : t -> int
