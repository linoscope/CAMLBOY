include Camlboy_lib

let show_dir = function
  | Envelope.Up -> "Up"
  | Envelope.Down -> "Down"

let%expect_test "initial state" =
  let env = Envelope.create () in
  Printf.printf "volume: %d, period: %d, direction: %s\n"
    (Envelope.get_volume env)
    (Envelope.get_period env)
    (show_dir (Envelope.get_direction env));
  [%expect {| volume: 0, period: 0, direction: Down |}]

let%expect_test "load_from_register" =
  let env = Envelope.create () in
  (* 0xFB = 1111_1011 = volume 15, direction up (bit 3 set), period 3 *)
  Envelope.load_from_register env ~register_value:0xFB;
  Printf.printf "volume: %d, direction: %s, period: %d\n"
    (Envelope.get_volume env)
    (show_dir (Envelope.get_direction env))
    (Envelope.get_period env);
  [%expect {| volume: 15, direction: Up, period: 3 |}]

let%expect_test "load_from_register direction down" =
  let env = Envelope.create () in
  (* 0xA2 = 1010_0010 = volume 10, direction down, period 2 *)
  Envelope.load_from_register env ~register_value:0xA2;
  Printf.printf "direction: %s\n" (show_dir (Envelope.get_direction env));
  [%expect {| direction: Down |}]

let%expect_test "clock does nothing when period is 0" =
  let env = Envelope.create () in
  Envelope.set_volume env 8;
  Envelope.set_period env 0;
  Envelope.trigger env;
  Envelope.clock env;
  Printf.printf "volume: %d\n" (Envelope.get_volume env);
  [%expect {| volume: 8 |}]

let%expect_test "clock decreases volume when direction is Down" =
  let env = Envelope.create () in
  Envelope.set_volume env 8;
  Envelope.set_period env 1;
  Envelope.set_direction env Envelope.Down;
  Envelope.trigger env;
  Envelope.clock env;
  Printf.printf "volume: %d\n" (Envelope.get_volume env);
  [%expect {| volume: 7 |}]

let%expect_test "clock increases volume when direction is Up" =
  let env = Envelope.create () in
  Envelope.set_volume env 8;
  Envelope.set_period env 1;
  Envelope.set_direction env Envelope.Up;
  Envelope.trigger env;
  Envelope.clock env;
  Printf.printf "volume: %d\n" (Envelope.get_volume env);
  [%expect {| volume: 9 |}]

let%expect_test "volume clamps at 0" =
  let env = Envelope.create () in
  Envelope.set_volume env 1;
  Envelope.set_period env 1;
  Envelope.set_direction env Envelope.Down;
  Envelope.trigger env;
  Envelope.clock env;  (* 1 -> 0 *)
  Printf.printf "volume after first clock: %d\n" (Envelope.get_volume env);
  Envelope.clock env;  (* Should stay at 0 *)
  Printf.printf "volume after second clock: %d\n" (Envelope.get_volume env);
  [%expect {|
    volume after first clock: 0
    volume after second clock: 0 |}]

let%expect_test "volume clamps at 15" =
  let env = Envelope.create () in
  Envelope.set_volume env 14;
  Envelope.set_period env 1;
  Envelope.set_direction env Envelope.Up;
  Envelope.trigger env;
  Envelope.clock env;  (* 14 -> 15 *)
  Printf.printf "volume after first clock: %d\n" (Envelope.get_volume env);
  Envelope.clock env;  (* Should stay at 15 *)
  Printf.printf "volume after second clock: %d\n" (Envelope.get_volume env);
  [%expect {|
    volume after first clock: 15
    volume after second clock: 15 |}]

let%expect_test "period delays volume change" =
  let env = Envelope.create () in
  Envelope.set_volume env 8;
  Envelope.set_period env 3;
  Envelope.set_direction env Envelope.Down;
  Envelope.trigger env;
  for i = 1 to 5 do
    Envelope.clock env;
    Printf.printf "clock %d: volume=%d\n" i (Envelope.get_volume env)
  done;
  [%expect {|
    clock 1: volume=8
    clock 2: volume=8
    clock 3: volume=7
    clock 4: volume=7
    clock 5: volume=7 |}]

let%expect_test "is_dac_enabled when volume > 0" =
  let env = Envelope.create () in
  Envelope.set_volume env 5;
  Envelope.set_direction env Envelope.Down;
  Printf.printf "dac enabled: %b\n" (Envelope.is_dac_enabled env);
  [%expect {| dac enabled: true |}]

let%expect_test "is_dac_enabled when direction is Up" =
  let env = Envelope.create () in
  Envelope.set_volume env 0;
  Envelope.set_direction env Envelope.Up;
  Printf.printf "dac enabled: %b\n" (Envelope.is_dac_enabled env);
  [%expect {| dac enabled: true |}]

let%expect_test "is_dac_disabled when volume 0 and direction Down" =
  let env = Envelope.create () in
  Envelope.set_volume env 0;
  Envelope.set_direction env Envelope.Down;
  Printf.printf "dac enabled: %b\n" (Envelope.is_dac_enabled env);
  [%expect {| dac enabled: false |}]

let%expect_test "reset clears all state" =
  let env = Envelope.create () in
  Envelope.set_volume env 10;
  Envelope.set_period env 5;
  Envelope.set_direction env Envelope.Up;
  Envelope.trigger env;
  Envelope.reset env;
  Printf.printf "volume: %d, period: %d, direction: %s\n"
    (Envelope.get_volume env)
    (Envelope.get_period env)
    (show_dir (Envelope.get_direction env));
  [%expect {| volume: 0, period: 0, direction: Down |}]

let%expect_test "full ramp down from 15" =
  let env = Envelope.create () in
  Envelope.set_volume env 15;
  Envelope.set_period env 1;
  Envelope.set_direction env Envelope.Down;
  Envelope.trigger env;
  for _ = 1 to 16 do
    Envelope.clock env
  done;
  Printf.printf "final volume: %d\n" (Envelope.get_volume env);
  [%expect {| final volume: 0 |}]
