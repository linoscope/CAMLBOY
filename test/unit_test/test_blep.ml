include Camlboy_lib

(* Helper to print float with fixed precision *)
let pf f = Printf.printf "%.4f" f

let%expect_test "poly_blep returns 0 in middle of waveform" =
  (* When t is far from edges, no correction needed *)
  let result = Blep.poly_blep ~t:0.5 ~dt:0.1 in
  pf result;
  [%expect {| 0.0000 |}]

let%expect_test "poly_blep returns 0 when dt <= 0" =
  let result = Blep.poly_blep ~t:0.1 ~dt:0.0 in
  pf result;
  [%expect {| 0.0000 |}]

let%expect_test "poly_blep negative near t=0 (just passed edge)" =
  (* Just after discontinuity at t=0, correction is negative *)
  let result = Blep.poly_blep ~t:0.05 ~dt:0.1 in
  Printf.printf "sign: %s, abs: " (if result < 0.0 then "neg" else "pos");
  pf (abs_float result);
  [%expect {| sign: neg, abs: 0.2500 |}]

let%expect_test "poly_blep positive near t=1 (approaching edge)" =
  (* Just before discontinuity at t=1, correction is positive *)
  let result = Blep.poly_blep ~t:0.95 ~dt:0.1 in
  Printf.printf "sign: %s, abs: " (if result > 0.0 then "pos" else "neg");
  pf (abs_float result);
  [%expect {| sign: pos, abs: 0.2500 |}]

let%expect_test "poly_blep symmetric around edges" =
  let near_start = Blep.poly_blep ~t:0.05 ~dt:0.1 in
  let near_end = Blep.poly_blep ~t:0.95 ~dt:0.1 in
  (* Approximately symmetric within floating point tolerance *)
  let diff = abs_float (abs_float near_start -. abs_float near_end) in
  Printf.printf "symmetric (diff < 1e-10): %b" (diff < 1e-10);
  [%expect {| symmetric (diff < 1e-10): true |}]

let%expect_test "square wave basic shape at 50% duty" =
  (* High in first half, low in second half *)
  let s1 = Blep.square ~phase:0.25 ~dt:0.01 ~duty:0.5 in
  let s2 = Blep.square ~phase:0.75 ~dt:0.01 ~duty:0.5 in
  Printf.printf "phase=0.25: %s, phase=0.75: %s"
    (if s1 > 0.0 then "high" else "low")
    (if s2 < 0.0 then "low" else "high");
  [%expect {| phase=0.25: high, phase=0.75: low |}]

let%expect_test "square wave 25% duty" =
  let s1 = Blep.square ~phase:0.1 ~dt:0.01 ~duty:0.25 in
  let s2 = Blep.square ~phase:0.5 ~dt:0.01 ~duty:0.25 in
  Printf.printf "phase=0.1: %s, phase=0.5: %s"
    (if s1 > 0.0 then "high" else "low")
    (if s2 < 0.0 then "low" else "high");
  [%expect {| phase=0.1: high, phase=0.5: low |}]

let%expect_test "square wave transitions are smoothed" =
  (* Near the rising edge, value should be between -1 and 1 *)
  let near_rise = Blep.square ~phase:0.01 ~dt:0.02 ~duty:0.5 in
  let far_from_edge = Blep.square ~phase:0.25 ~dt:0.02 ~duty:0.5 in
  Printf.printf "near_rise in range: %b, far_from_edge: %.1f"
    (near_rise > -1.0 && near_rise < 1.0)
    far_from_edge;
  [%expect {| near_rise in range: true, far_from_edge: 1.0 |}]

let%expect_test "BLEP functor with Square_channel" =
  let module BlepSquare = Blep.Make(Square_channel) in
  let ch = Square_channel.create ~has_sweep:false in
  let env = Square_channel.get_envelope ch in
  Envelope.set_volume env 15;
  Square_channel.update_dac ch;
  Square_channel.set_frequency ch 1024;
  Square_channel.set_duty ch Square_channel.Duty_50;
  Square_channel.trigger ch;
  let phase = BlepSquare.get_phase ch in
  let dt = BlepSquare.get_dt ch ~sample_rate:44100 in
  let sample = BlepSquare.get_sample ch ~sample_rate:44100 in
  Printf.printf "phase: %.3f, dt: %.6f, sample in range: %b"
    phase dt (sample >= -1.0 && sample <= 1.0);
  [%expect {| phase: 0.000, dt: 0.002902, sample in range: true |}]

let%expect_test "BLEP returns 0 when channel inactive" =
  let module BlepSquare = Blep.Make(Square_channel) in
  let ch = Square_channel.create ~has_sweep:false in
  (* Channel not triggered, should be inactive *)
  let sample = BlepSquare.get_sample ch ~sample_rate:44100 in
  pf sample;
  [%expect {| 0.0000 |}]

let%expect_test "BLEP get_dt is proportional to frequency" =
  let module BlepSquare = Blep.Make(Square_channel) in
  let ch = Square_channel.create ~has_sweep:false in
  Square_channel.set_frequency ch 0;
  let dt_low = BlepSquare.get_dt ch ~sample_rate:44100 in
  Square_channel.set_frequency ch 1024;
  let dt_mid = BlepSquare.get_dt ch ~sample_rate:44100 in
  Square_channel.set_frequency ch 2040;
  let dt_high = BlepSquare.get_dt ch ~sample_rate:44100 in
  Printf.printf "dt increases with freq register: %b"
    (dt_low < dt_mid && dt_mid < dt_high);
  [%expect {| dt increases with freq register: true |}]

let%expect_test "BLEP phase advances as channel runs" =
  let module BlepSquare = Blep.Make(Square_channel) in
  let ch = Square_channel.create ~has_sweep:false in
  let env = Square_channel.get_envelope ch in
  Envelope.set_volume env 15;
  Square_channel.update_dac ch;
  Square_channel.set_frequency ch 2044;
  Square_channel.trigger ch;
  let p1 = BlepSquare.get_phase ch in
  Square_channel.run ch ~mcycles:4;
  let p2 = BlepSquare.get_phase ch in
  Printf.printf "phase advanced: %b (%.3f -> %.3f)" (p2 > p1) p1 p2;
  [%expect {| phase advanced: true (0.000 -> 0.125) |}]
