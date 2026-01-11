(** Audio Buffer - Ring buffer for accumulating audio samples.

    The APU generates samples at the emulated sample rate (e.g., 44100 Hz).
    These samples are stored in a ring buffer that the audio backend
    (e.g., SDL2) can pull from via callback.

    The buffer uses interleaved stereo int16 bigarray format (L R L R ...)
    for efficient blitting directly to SDL audio buffers. *)

(** Bigarray type for interleaved stereo audio samples. *)
type ba = (int, Bigarray.int16_signed_elt, Bigarray.c_layout) Bigarray.Array1.t

(** A stereo audio sample. *)
type sample = {
  left : int;   (** Left channel value (-32768 to 32767) *)
  right : int;  (** Right channel value (-32768 to 32767) *)
}

type t

(** Create a new audio buffer.
    @param capacity Maximum number of samples the buffer can hold *)
val create : int -> t

(** Check if the buffer is full. *)
val is_full : t -> bool

(** Check if the buffer is empty. *)
val is_empty : t -> bool

(** Get number of samples available for reading. *)
val available : t -> int

(** Get number of slots available for writing. *)
val space_available : t -> int

(** Push a stereo sample to the buffer.
    Returns true if successful, false if buffer is full. *)
val push : t -> left:int -> right:int -> bool

(** Pop a sample from the buffer. Returns None if empty. *)
val pop : t -> sample option

(** Pop multiple samples into destination bigarray using blit.
    The destination should be interleaved stereo (L R L R ...).
    Returns the number of samples actually read.
    @param dst Bigarray to fill with interleaved stereo samples
    @param count Maximum number of samples to read *)
val pop_into : t -> dst:ba -> count:int -> int

(** Clear the buffer, discarding all samples. *)
val clear : t -> unit

(** Get the buffer capacity (maximum number of samples it can hold). *)
val capacity : t -> int
