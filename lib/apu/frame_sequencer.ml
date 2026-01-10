(* Frame Sequencer - drives length counter, envelope, and sweep at specific intervals.

   The frame sequencer runs at 512 Hz and cycles through 8 steps (0-7),
   each triggering different clocks:

   Step 0: Length
   Step 1: -
   Step 2: Length, Sweep
   Step 3: -
   Step 4: Length
   Step 5: -
   Step 6: Length, Sweep
   Step 7: Envelope

   Timing derivation:
   - CPU clock: 4,194,304 Hz (T-cycles per second)
   - Frame sequencer: 512 Hz (steps per second)
   - T-cycles per step: cpu_freq / frame_seq_freq = 4194304 / 512 = 8192
   - M-cycles per step: 8192 / 4 = 2048

   Reference: https://gbdev.gg8.se/wiki/articles/Gameboy_sound_hardware#Frame_Sequencer *)

type clock_event =
  | Length
  | Envelope
  | Sweep

type t = {
  mutable counter : int;  (* Counts M-cycles until next step *)
  mutable step : int;     (* Current step 0-7 *)
  mcycles_per_step : int; (* Derived from timing parameters *)
}

let create
    ?(cpu_freq = Constants.cpu_freq)
    ?(frame_seq_freq = Constants.frame_seq_freq)
    ?(tcycles_per_mcycle = Constants.tcycles_per_mcycle)
    () =
  let tcycles_per_step = cpu_freq / frame_seq_freq in
  let mcycles_per_step = tcycles_per_step / tcycles_per_mcycle in
  {
    counter = mcycles_per_step;
    step = 0;
    mcycles_per_step;
  }

let reset t =
  t.counter <- t.mcycles_per_step;
  t.step <- 0

(* Run the frame sequencer for the given number of M-cycles.
   Returns a list of clock events that occurred during this time. *)
let run t ~mcycles =
  t.counter <- t.counter - mcycles;
  let events = ref [] in
  while t.counter <= 0 do
    t.counter <- t.counter + t.mcycles_per_step;
    (* Determine which clocks fire based on current step *)
    begin match t.step with
      | 0 | 4 ->
        events := Length :: !events
      | 2 | 6 ->
        events := Sweep :: Length :: !events
      | 7 ->
        events := Envelope :: !events
      | 1 | 3 | 5 ->
        ()  (* No clocks on these steps *)
      | _ ->
        ()  (* Should not happen *)
    end;
    t.step <- (t.step + 1) land 7  (* Wrap around 0-7 *)
  done;
  (* Return events in chronological order (we built them in reverse) *)
  List.rev !events

(* Get current step for testing *)
let get_step t = t.step

(* Get current counter for testing *)
let get_counter t = t.counter

(* Check if the NEXT step will clock the length counter.
   Length clocks on steps 0, 2, 4, 6 (even steps).
   So next step clocks length if current step is odd (1, 3, 5, 7).

   Obscure behavior: Extra length clocking occurs when writing to NRx4
   when the next step DOESN'T clock length (i.e., when current step is even).
   Reference: https://gbdev.gg8.se/wiki/articles/Gameboy_sound_hardware#Length_Counter *)
let next_step_clocks_length t =
  t.step land 1 = 1  (* Current step is odd means next step is even *)
