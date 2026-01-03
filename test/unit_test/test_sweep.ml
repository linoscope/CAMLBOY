include Camlboy_lib

let%expect_test "initial state" =
  let sw = Sweep.create () in
  Printf.printf "enabled: %b, period: %d, negate: %b, shift: %d\n"
    (Sweep.is_enabled sw)
    (Sweep.get_period sw)
    (Sweep.get_negate sw)
    (Sweep.get_shift sw);
  [%expect {| enabled: false, period: 0, negate: false, shift: 0 |}]

let%expect_test "load_from_register" =
  let sw = Sweep.create () in
  (* 0x73 = 0111_0011 = period 7, negate false, shift 3 *)
  Sweep.load_from_register sw ~register_value:0x73;
  Printf.printf "period: %d, negate: %b, shift: %d\n"
    (Sweep.get_period sw)
    (Sweep.get_negate sw)
    (Sweep.get_shift sw);
  [%expect {| period: 7, negate: false, shift: 3 |}]

let%expect_test "load_from_register with negate" =
  let sw = Sweep.create () in
  (* 0x1A = 0001_1010 = period 1, negate true, shift 2 *)
  Sweep.load_from_register sw ~register_value:0x1A;
  Printf.printf "period: %d, negate: %b, shift: %d\n"
    (Sweep.get_period sw)
    (Sweep.get_negate sw)
    (Sweep.get_shift sw);
  [%expect {| period: 1, negate: true, shift: 2 |}]

let%expect_test "trigger enables sweep when period > 0" =
  let sw = Sweep.create () in
  Sweep.load_from_register sw ~register_value:0x21;  (* period=2, shift=1 *)
  let overflow = Sweep.trigger sw ~frequency:1000 in
  Printf.printf "enabled: %b, overflow: %b, shadow: %d\n"
    (Sweep.is_enabled sw) overflow (Sweep.get_shadow_frequency sw);
  [%expect {| enabled: true, overflow: false, shadow: 1000 |}]

let%expect_test "trigger enables sweep when shift > 0" =
  let sw = Sweep.create () in
  Sweep.load_from_register sw ~register_value:0x01;  (* period=0, shift=1 *)
  let overflow = Sweep.trigger sw ~frequency:1000 in
  Printf.printf "enabled: %b, overflow: %b\n" (Sweep.is_enabled sw) overflow;
  [%expect {| enabled: true, overflow: false |}]

let%expect_test "trigger disabled when period=0 and shift=0" =
  let sw = Sweep.create () in
  Sweep.load_from_register sw ~register_value:0x00;
  let _ = Sweep.trigger sw ~frequency:1000 in
  Printf.printf "enabled: %b\n" (Sweep.is_enabled sw);
  [%expect {| enabled: false |}]

let%expect_test "trigger overflow check when shift > 0" =
  let sw = Sweep.create () in
  (* Shift=1 means delta = 1500 >> 1 = 750, new_freq = 1500 + 750 = 2250 > 2047 *)
  Sweep.load_from_register sw ~register_value:0x11;  (* period=1, shift=1 *)
  let overflow = Sweep.trigger sw ~frequency:1500 in
  Printf.printf "overflow: %b\n" overflow;
  [%expect {| overflow: true |}]

let%expect_test "clock increases frequency" =
  let sw = Sweep.create () in
  Sweep.load_from_register sw ~register_value:0x11;  (* period=1, negate=false, shift=1 *)
  let _ = Sweep.trigger sw ~frequency:500 in
  (* After trigger, timer=1. First clock decrements to 0 and does calculation. *)
  let (new_freq, disable) = Sweep.clock sw in
  Printf.printf "new_freq: %s, disable: %b\n"
    (match new_freq with Some f -> string_of_int f | None -> "none")
    disable;
  (* new_freq = 500 + (500 >> 1) = 500 + 250 = 750 *)
  (* Second check: 750 + 375 = 1125 < 2048, no overflow *)
  [%expect {| new_freq: 750, disable: false |}]

let%expect_test "clock decreases frequency when negate" =
  let sw = Sweep.create () in
  Sweep.load_from_register sw ~register_value:0x19;  (* period=1, negate=true, shift=1 *)
  let _ = Sweep.trigger sw ~frequency:1000 in
  let (new_freq, _) = Sweep.clock sw in
  Printf.printf "new_freq: %s\n"
    (match new_freq with Some f -> string_of_int f | None -> "none");
  (* new_freq = 1000 - (1000 >> 1) = 1000 - 500 = 500 *)
  [%expect {| new_freq: 500 |}]

let%expect_test "clock respects period" =
  let sw = Sweep.create () in
  Sweep.load_from_register sw ~register_value:0x31;  (* period=3, shift=1 *)
  let _ = Sweep.trigger sw ~frequency:1000 in
  (* Timer starts at 3. Need 3 clocks before calculation. *)
  let (freq1, _) = Sweep.clock sw in
  let (freq2, _) = Sweep.clock sw in
  let (freq3, _) = Sweep.clock sw in
  Printf.printf "clock1: %s, clock2: %s, clock3: %s\n"
    (match freq1 with Some f -> string_of_int f | None -> "none")
    (match freq2 with Some f -> string_of_int f | None -> "none")
    (match freq3 with Some f -> string_of_int f | None -> "none");
  [%expect {| clock1: none, clock2: none, clock3: 1500 |}]

let%expect_test "clock overflow disables" =
  let sw = Sweep.create () in
  Sweep.load_from_register sw ~register_value:0x11;  (* period=1, shift=1 *)
  (* Start at 1800, first sweep gives 1800 + 900 = 2700 > 2047 *)
  let _ = Sweep.trigger sw ~frequency:1400 in  (* trigger OK: 1400+700=2100 but we check at trigger *)
  (* Actually trigger does check... let's use a value that passes trigger but fails clock *)
  Sweep.reset sw;
  Sweep.load_from_register sw ~register_value:0x12;  (* period=1, shift=2 *)
  (* With shift=2: 1800 + (1800 >> 2) = 1800 + 450 = 2250 > 2047 *)
  (* But trigger with shift=2: 1800 + 450 = 2250, overflow at trigger *)
  (* Let's use shift=3: trigger 1600 + 200 = 1800 OK, then clock 1800 + 225 = 2025 OK, *)
  (* then next clock 2025 + 253 = 2278 overflow *)
  Sweep.reset sw;
  Sweep.load_from_register sw ~register_value:0x13;  (* period=1, shift=3 *)
  let overflow = Sweep.trigger sw ~frequency:1600 in
  Printf.printf "trigger overflow: %b\n" overflow;
  let (_, disable1) = Sweep.clock sw in
  Printf.printf "after clock1 disable: %b, shadow: %d\n" disable1 (Sweep.get_shadow_frequency sw);
  let (_, disable2) = Sweep.clock sw in
  Printf.printf "after clock2 disable: %b\n" disable2;
  [%expect {|
    trigger overflow: false
    after clock1 disable: false, shadow: 1800
    after clock2 disable: true |}]

let%expect_test "clock with shift=0 does not change frequency" =
  let sw = Sweep.create () in
  Sweep.load_from_register sw ~register_value:0x10;  (* period=1, shift=0 *)
  let _ = Sweep.trigger sw ~frequency:1000 in
  let (new_freq, _) = Sweep.clock sw in
  Printf.printf "new_freq: %s\n"
    (match new_freq with Some f -> string_of_int f | None -> "none");
  [%expect {| new_freq: none |}]

let%expect_test "clock when disabled does nothing" =
  let sw = Sweep.create () in
  Sweep.load_from_register sw ~register_value:0x00;  (* period=0, shift=0 *)
  let _ = Sweep.trigger sw ~frequency:1000 in
  let (new_freq, disable) = Sweep.clock sw in
  Printf.printf "new_freq: %s, disable: %b\n"
    (match new_freq with Some f -> string_of_int f | None -> "none")
    disable;
  [%expect {| new_freq: none, disable: false |}]

let%expect_test "reset clears all state" =
  let sw = Sweep.create () in
  Sweep.load_from_register sw ~register_value:0x73;
  let _ = Sweep.trigger sw ~frequency:1000 in
  Sweep.reset sw;
  Printf.printf "enabled: %b, shadow: %d, period: %d\n"
    (Sweep.is_enabled sw)
    (Sweep.get_shadow_frequency sw)
    (Sweep.get_period sw);
  [%expect {| enabled: false, shadow: 0, period: 0 |}]

let%expect_test "negate_to_positive_switch detection" =
  let sw = Sweep.create () in
  Sweep.load_from_register sw ~register_value:0x19;  (* negate=true *)
  let _ = Sweep.trigger sw ~frequency:1000 in
  let _ = Sweep.clock sw in  (* This uses negate *)
  let should_disable = Sweep.check_negate_to_positive_switch sw ~new_negate:false in
  Printf.printf "should disable: %b\n" should_disable;
  [%expect {| should disable: true |}]
