(** Web Audio API bindings for OCaml/Brr.

    Provides bindings for AudioContext, ScriptProcessorNode, and related types
    needed for Game Boy audio output. *)

(** Audio node base type. *)
module AudioNode = struct
  type t = Jv.t

  let connect (node : t) (dest : t) : unit =
    ignore @@ Jv.call node "connect" [| dest |]

  let disconnect (node : t) : unit =
    ignore @@ Jv.call node "disconnect" [||]
end

(** Audio destination node - the final output (speakers). *)
module AudioDestinationNode = struct
  type t = Jv.t

  let as_node (t : t) : AudioNode.t = t
end

(** Audio buffer for storing audio samples. *)
module AudioBuffer = struct
  type t = Jv.t

  let get_channel_data (buf : t) (channel : int) : Jv.t =
    Jv.call buf "getChannelData" [| Jv.of_int channel |]
end

(** ScriptProcessorNode for custom audio processing.
    Note: Deprecated but still widely supported and simpler than AudioWorklet
    for integration with OCaml/WASM. *)
module ScriptProcessorNode = struct
  type t = Jv.t

  (** Audio processing event data. *)
  module AudioProcessingEvent = struct
    type t = Jv.t

    let output_buffer (ev : t) : AudioBuffer.t =
      Jv.get ev "outputBuffer"

    let input_buffer (ev : t) : AudioBuffer.t =
      Jv.get ev "inputBuffer"
  end

  let as_node (t : t) : AudioNode.t = t

  (** Set the onaudioprocess callback. *)
  let set_onaudioprocess (node : t) (f : AudioProcessingEvent.t -> unit) : unit =
    let cb = Jv.callback ~arity:1 f in
    Jv.set node "onaudioprocess" cb
end

(** Audio context - the main interface for Web Audio API. *)
module AudioContext = struct
  type t = Jv.t

  type state = Suspended | Running | Closed

  let state_of_string = function
    | "suspended" -> Suspended
    | "running" -> Running
    | "closed" -> Closed
    | s -> failwith ("Unknown AudioContext state: " ^ s)

  (** Create a new AudioContext. *)
  let create ?sample_rate () : t =
    let opts = match sample_rate with
      | None -> Jv.undefined
      | Some rate -> Jv.obj [| ("sampleRate", Jv.of_int rate) |]
    in
    Jv.new' (Jv.get Jv.global "AudioContext") [| opts |]

  (** Get the sample rate of the audio context. *)
  let sample_rate (ctx : t) : int =
    Jv.Float.get ctx "sampleRate" |> int_of_float

  (** Get current audio time in seconds. *)
  let current_time (ctx : t) : float =
    Jv.Float.get ctx "currentTime"

  (** Get the current state of the audio context. *)
  let state (ctx : t) : state =
    Jv.Jstr.get ctx "state" |> Jstr.to_string |> state_of_string

  (** Get the destination node (speakers). *)
  let destination (ctx : t) : AudioDestinationNode.t =
    Jv.get ctx "destination"

  (** Resume a suspended audio context (needed after user interaction). *)
  let resume (ctx : t) : unit Fut.t =
    let open Fut.Syntax in
    let promise = Jv.call ctx "resume" [||] in
    let+ _ = Fut.of_promise ~ok:(fun _ -> ()) promise in
    ()

  (** Close the audio context. *)
  let close (ctx : t) : unit Fut.t =
    let open Fut.Syntax in
    let promise = Jv.call ctx "close" [||] in
    let+ _ = Fut.of_promise ~ok:(fun _ -> ()) promise in
    ()

  (** Create a ScriptProcessorNode for custom audio processing. *)
  let create_script_processor
      (ctx : t)
      ~buffer_size
      ~input_channels
      ~output_channels : ScriptProcessorNode.t =
    Jv.call ctx "createScriptProcessor"
      [| Jv.of_int buffer_size;
         Jv.of_int input_channels;
         Jv.of_int output_channels |]
end
