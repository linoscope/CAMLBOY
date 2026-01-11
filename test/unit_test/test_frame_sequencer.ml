include Camlboy_lib

let show_events events =
  events
  |> List.map (function
      | Frame_sequencer.Length -> "Length"
      | Frame_sequencer.Envelope -> "Envelope"
      | Frame_sequencer.Sweep -> "Sweep")
  |> String.concat ", "
  |> Printf.printf "[%s]\n"

let%expect_test "default timing: 2048 mcycles per step" =
  let fs = Frame_sequencer.create () in
  Printf.printf "initial step: %d\n" (Frame_sequencer.get_step fs);
  Printf.printf "initial counter: %d\n" (Frame_sequencer.get_counter fs);
  [%expect {|
    initial step: 0
    initial counter: 2048 |}]

let%expect_test "custom timing for easier testing" =
  (* Use smaller values for easier testing: 8 mcycles per step *)
  let fs = Frame_sequencer.create
      ~cpu_freq:32
      ~frame_seq_freq:1
      ~tcycles_per_mcycle:4
      ()
  in
  Printf.printf "mcycles per step: %d\n" (Frame_sequencer.get_counter fs);
  [%expect {| mcycles per step: 8 |}]

let%expect_test "step 0 fires Length" =
  let fs = Frame_sequencer.create ~cpu_freq:32 ~frame_seq_freq:1 ~tcycles_per_mcycle:4 () in
  (* Run exactly one step worth of mcycles *)
  let events = Frame_sequencer.run fs ~mcycles:8 in
  show_events events;
  Printf.printf "new step: %d\n" (Frame_sequencer.get_step fs);
  [%expect {|
    [Length]
    new step: 1 |}]

let%expect_test "step 1 fires nothing" =
  let fs = Frame_sequencer.create ~cpu_freq:32 ~frame_seq_freq:1 ~tcycles_per_mcycle:4 () in
  let _ = Frame_sequencer.run fs ~mcycles:8 in  (* step 0 -> 1 *)
  let events = Frame_sequencer.run fs ~mcycles:8 in  (* step 1 -> 2 *)
  show_events events;
  Printf.printf "new step: %d\n" (Frame_sequencer.get_step fs);
  [%expect {|
    []
    new step: 2 |}]

let%expect_test "step 2 fires Length and Sweep" =
  let fs = Frame_sequencer.create ~cpu_freq:32 ~frame_seq_freq:1 ~tcycles_per_mcycle:4 () in
  let _ = Frame_sequencer.run fs ~mcycles:16 in  (* step 0 -> 2 *)
  let events = Frame_sequencer.run fs ~mcycles:8 in  (* step 2 -> 3 *)
  show_events events;
  [%expect {| [Length, Sweep] |}]

let%expect_test "step 7 fires Envelope" =
  let fs = Frame_sequencer.create ~cpu_freq:32 ~frame_seq_freq:1 ~tcycles_per_mcycle:4 () in
  let _ = Frame_sequencer.run fs ~mcycles:(7 * 8) in  (* step 0 -> 7 *)
  let events = Frame_sequencer.run fs ~mcycles:8 in  (* step 7 -> 0 *)
  show_events events;
  Printf.printf "new step: %d\n" (Frame_sequencer.get_step fs);
  [%expect {|
    [Envelope]
    new step: 0 |}]

let%expect_test "full cycle through all 8 steps" =
  let fs = Frame_sequencer.create ~cpu_freq:32 ~frame_seq_freq:1 ~tcycles_per_mcycle:4 () in
  for step = 0 to 7 do
    let events = Frame_sequencer.run fs ~mcycles:8 in
    Printf.printf "step %d: " step;
    show_events events
  done;
  [%expect {|
    step 0: [Length]
    step 1: []
    step 2: [Length, Sweep]
    step 3: []
    step 4: [Length]
    step 5: []
    step 6: [Length, Sweep]
    step 7: [Envelope] |}]

let%expect_test "multiple steps in single run" =
  let fs = Frame_sequencer.create ~cpu_freq:32 ~frame_seq_freq:1 ~tcycles_per_mcycle:4 () in
  (* Run 3 steps worth of mcycles at once *)
  let events = Frame_sequencer.run fs ~mcycles:24 in
  show_events events;
  Printf.printf "new step: %d\n" (Frame_sequencer.get_step fs);
  [%expect {|
    [Length, Length, Sweep]
    new step: 3 |}]

let%expect_test "reset restores initial state" =
  let fs = Frame_sequencer.create ~cpu_freq:32 ~frame_seq_freq:1 ~tcycles_per_mcycle:4 () in
  let _ = Frame_sequencer.run fs ~mcycles:32 in  (* Advance 4 steps *)
  Printf.printf "before reset: step=%d\n" (Frame_sequencer.get_step fs);
  Frame_sequencer.reset fs;
  Printf.printf "after reset: step=%d, counter=%d\n"
    (Frame_sequencer.get_step fs) (Frame_sequencer.get_counter fs);
  [%expect {|
    before reset: step=4
    after reset: step=0, counter=8 |}]

let%expect_test "partial mcycles accumulate correctly" =
  let fs = Frame_sequencer.create ~cpu_freq:32 ~frame_seq_freq:1 ~tcycles_per_mcycle:4 () in
  (* Run 3 mcycles (not enough for a step) *)
  let events = Frame_sequencer.run fs ~mcycles:3 in
  show_events events;
  Printf.printf "counter after 3: %d\n" (Frame_sequencer.get_counter fs);
  (* Run 4 more (still not enough, total 7) *)
  let events = Frame_sequencer.run fs ~mcycles:4 in
  show_events events;
  Printf.printf "counter after 7: %d\n" (Frame_sequencer.get_counter fs);
  (* Run 1 more (now we hit 8) *)
  let events = Frame_sequencer.run fs ~mcycles:1 in
  show_events events;
  Printf.printf "step after 8: %d\n" (Frame_sequencer.get_step fs);
  [%expect {|
    []
    counter after 3: 5
    []
    counter after 7: 1
    [Length]
    step after 8: 1 |}]
