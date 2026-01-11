(** Web Audio API bindings for OCaml/Brr.

    Provides bindings for AudioContext, ScriptProcessorNode, and related types
    needed for Game Boy audio output. *)

(** Audio node base type. *)
module AudioNode : sig
  type t

  (** Connect this node to another node or destination. *)
  val connect : t -> t -> unit

  (** Disconnect this node from all outputs. *)
  val disconnect : t -> unit
end

(** Audio destination node - the final output (speakers). *)
module AudioDestinationNode : sig
  type t

  (** Convert to AudioNode for connecting. *)
  val as_node : t -> AudioNode.t
end

(** Audio buffer for storing audio samples. *)
module AudioBuffer : sig
  type t

  (** Get the Float32Array for a specific channel. *)
  val get_channel_data : t -> int -> Jv.t
end

(** ScriptProcessorNode for custom audio processing.
    Note: Deprecated but still widely supported and simpler than AudioWorklet
    for integration with OCaml/WASM. *)
module ScriptProcessorNode : sig
  type t

  (** Audio processing event data. *)
  module AudioProcessingEvent : sig
    type t

    (** Get the output buffer to fill with audio samples. *)
    val output_buffer : t -> AudioBuffer.t

    (** Get the input buffer (if any). *)
    val input_buffer : t -> AudioBuffer.t
  end

  (** Convert to AudioNode for connecting. *)
  val as_node : t -> AudioNode.t

  (** Set the onaudioprocess callback. Called when audio data is needed. *)
  val set_onaudioprocess : t -> (AudioProcessingEvent.t -> unit) -> unit
end

(** Audio context - the main interface for Web Audio API. *)
module AudioContext : sig
  type t

  type state = Suspended | Running | Closed

  (** Create a new AudioContext with optional sample rate. *)
  val create : ?sample_rate:int -> unit -> t

  (** Get the sample rate of the audio context. *)
  val sample_rate : t -> int

  (** Get current audio time in seconds. *)
  val current_time : t -> float

  (** Get the current state of the audio context. *)
  val state : t -> state

  (** Get the destination node (speakers). *)
  val destination : t -> AudioDestinationNode.t

  (** Resume a suspended audio context (needed after user interaction). *)
  val resume : t -> unit Fut.t

  (** Close the audio context. *)
  val close : t -> unit Fut.t

  (** Create a ScriptProcessorNode for custom audio processing.
      @param buffer_size Buffer size (must be power of 2: 256-16384)
      @param input_channels Number of input channels (0 for no input)
      @param output_channels Number of output channels *)
  val create_script_processor :
    t ->
    buffer_size:int ->
    input_channels:int ->
    output_channels:int ->
    ScriptProcessorNode.t
end
