include Camlboy_lib

let%expect_test "create with max_length 64" =
  let lc = Length_counter.create ~max_length:64 in
  Printf.printf "counter: %d, max: %d, enabled: %b\n"
    (Length_counter.get_counter lc)
    (Length_counter.get_max_length lc)
    (Length_counter.is_enabled lc);
  [%expect {| counter: 0, max: 64, enabled: false |}]

let%expect_test "create with max_length 256 (wave)" =
  let lc = Length_counter.create ~max_length:256 in
  Printf.printf "max: %d\n" (Length_counter.get_max_length lc);
  [%expect {| max: 256 |}]

let%expect_test "clock does nothing when disabled" =
  let lc = Length_counter.create ~max_length:64 in
  Length_counter.set_length lc 10;
  let disabled = Length_counter.clock lc in
  Printf.printf "disabled: %b, counter: %d\n" disabled (Length_counter.get_counter lc);
  [%expect {| disabled: false, counter: 10 |}]

let%expect_test "clock decrements when enabled" =
  let lc = Length_counter.create ~max_length:64 in
  Length_counter.set_length lc 10;
  Length_counter.set_enabled lc true;
  let disabled = Length_counter.clock lc in
  Printf.printf "disabled: %b, counter: %d\n" disabled (Length_counter.get_counter lc);
  [%expect {| disabled: false, counter: 9 |}]

let%expect_test "clock returns true when reaching zero" =
  let lc = Length_counter.create ~max_length:64 in
  Length_counter.set_length lc 1;
  Length_counter.set_enabled lc true;
  let disabled = Length_counter.clock lc in
  Printf.printf "disabled: %b, counter: %d\n" disabled (Length_counter.get_counter lc);
  [%expect {| disabled: true, counter: 0 |}]

let%expect_test "clock does nothing at zero" =
  let lc = Length_counter.create ~max_length:64 in
  Length_counter.set_length lc 0;
  Length_counter.set_enabled lc true;
  let disabled = Length_counter.clock lc in
  Printf.printf "disabled: %b, counter: %d\n" disabled (Length_counter.get_counter lc);
  [%expect {| disabled: false, counter: 0 |}]

let%expect_test "load_from_register calculates correct length" =
  let lc = Length_counter.create ~max_length:64 in
  (* Register value 60 means length = 64 - 60 = 4 *)
  Length_counter.load_from_register lc ~register_value:60;
  Printf.printf "counter: %d\n" (Length_counter.get_counter lc);
  [%expect {| counter: 4 |}]

let%expect_test "load_from_register with max_length 256" =
  let lc = Length_counter.create ~max_length:256 in
  (* Register value 200 means length = 256 - 200 = 56 *)
  Length_counter.load_from_register lc ~register_value:200;
  Printf.printf "counter: %d\n" (Length_counter.get_counter lc);
  [%expect {| counter: 56 |}]

let%expect_test "trigger reloads to max when counter is 0" =
  let lc = Length_counter.create ~max_length:64 in
  Printf.printf "before trigger: %d\n" (Length_counter.get_counter lc);
  Length_counter.trigger lc ~next_step_clocks_length:true;
  Printf.printf "after trigger: %d\n" (Length_counter.get_counter lc);
  [%expect {|
    before trigger: 0
    after trigger: 64 |}]

let%expect_test "trigger does not change non-zero counter" =
  let lc = Length_counter.create ~max_length:64 in
  Length_counter.set_length lc 10;
  Length_counter.trigger lc ~next_step_clocks_length:true;
  Printf.printf "counter: %d\n" (Length_counter.get_counter lc);
  [%expect {| counter: 10 |}]

let%expect_test "reset clears counter and disables" =
  let lc = Length_counter.create ~max_length:64 in
  Length_counter.set_length lc 30;
  Length_counter.set_enabled lc true;
  Length_counter.reset lc;
  Printf.printf "counter: %d, enabled: %b\n"
    (Length_counter.get_counter lc)
    (Length_counter.is_enabled lc);
  [%expect {| counter: 0, enabled: false |}]

(* Obscure behavior: if triggered when next step doesn't clock length,
   AND length is enabled, AND counter was 0, set to max-1 instead of max.
   Reference: https://gbdev.gg8.se/wiki/articles/Gameboy_sound_hardware#Trigger_Event *)
let%expect_test "trigger with enabled length on non-length step sets max-1 (obscure behavior)" =
  let lc = Length_counter.create ~max_length:64 in
  Length_counter.set_enabled lc true;
  (* next_step_clocks_length:false means we're on an even step (0,2,4,6),
     so next step is odd and won't clock length *)
  Length_counter.trigger lc ~next_step_clocks_length:false;
  Printf.printf "counter: %d (expected: 63)\n" (Length_counter.get_counter lc);
  [%expect {| counter: 63 (expected: 63) |}]

let%expect_test "trigger with enabled length on length step sets max (normal)" =
  let lc = Length_counter.create ~max_length:64 in
  Length_counter.set_enabled lc true;
  (* next_step_clocks_length:true means we're on an odd step,
     so next step is even and WILL clock length - no quirk *)
  Length_counter.trigger lc ~next_step_clocks_length:true;
  Printf.printf "counter: %d (expected: 64)\n" (Length_counter.get_counter lc);
  [%expect {| counter: 64 (expected: 64) |}]

let%expect_test "trigger with disabled length on non-length step sets max (no quirk)" =
  let lc = Length_counter.create ~max_length:64 in
  (* Length is disabled, so no quirk even on non-length step *)
  Length_counter.trigger lc ~next_step_clocks_length:false;
  Printf.printf "counter: %d (expected: 64)\n" (Length_counter.get_counter lc);
  [%expect {| counter: 64 (expected: 64) |}]

let%expect_test "trigger quirk for wave channel (max 256 -> 255)" =
  let lc = Length_counter.create ~max_length:256 in
  Length_counter.set_enabled lc true;
  Length_counter.trigger lc ~next_step_clocks_length:false;
  Printf.printf "counter: %d (expected: 255)\n" (Length_counter.get_counter lc);
  [%expect {| counter: 255 (expected: 255) |}]

(* Obscure behavior: extra clocking when enabling length on non-length step.
   Reference: https://gbdev.gg8.se/wiki/articles/Gameboy_sound_hardware#Length_Counter *)
let%expect_test "extra clock on enable when next step doesn't clock length (obscure behavior)" =
  let lc = Length_counter.create ~max_length:64 in
  Length_counter.set_length lc 5;
  (* Enable length when next step doesn't clock *)
  Length_counter.set_enabled lc true;
  let disabled = Length_counter.extra_clock_on_enable lc
    ~was_enabled:false ~next_step_clocks_length:false in
  Printf.printf "counter: %d, disabled: %b\n" (Length_counter.get_counter lc) disabled;
  [%expect {| counter: 4, disabled: false |}]

let%expect_test "extra clock disables channel when counter reaches 0" =
  let lc = Length_counter.create ~max_length:64 in
  Length_counter.set_length lc 1;
  Length_counter.set_enabled lc true;
  let disabled = Length_counter.extra_clock_on_enable lc
    ~was_enabled:false ~next_step_clocks_length:false in
  Printf.printf "counter: %d, disabled: %b\n" (Length_counter.get_counter lc) disabled;
  [%expect {| counter: 0, disabled: true |}]

let%expect_test "no extra clock when was already enabled" =
  let lc = Length_counter.create ~max_length:64 in
  Length_counter.set_length lc 5;
  Length_counter.set_enabled lc true;
  let disabled = Length_counter.extra_clock_on_enable lc
    ~was_enabled:true ~next_step_clocks_length:false in
  Printf.printf "counter: %d, disabled: %b\n" (Length_counter.get_counter lc) disabled;
  [%expect {| counter: 5, disabled: false |}]

let%expect_test "no extra clock when next step clocks length" =
  let lc = Length_counter.create ~max_length:64 in
  Length_counter.set_length lc 5;
  Length_counter.set_enabled lc true;
  let disabled = Length_counter.extra_clock_on_enable lc
    ~was_enabled:false ~next_step_clocks_length:true in
  Printf.printf "counter: %d, disabled: %b\n" (Length_counter.get_counter lc) disabled;
  [%expect {| counter: 5, disabled: false |}]

let%expect_test "full countdown to zero" =
  let lc = Length_counter.create ~max_length:64 in
  Length_counter.set_length lc 3;
  Length_counter.set_enabled lc true;
  for i = 3 downto 1 do
    let disabled = Length_counter.clock lc in
    Printf.printf "clock %d: counter=%d, disabled=%b\n"
      (4 - i) (Length_counter.get_counter lc) disabled
  done;
  [%expect {|
    clock 1: counter=2, disabled=false
    clock 2: counter=1, disabled=false
    clock 3: counter=0, disabled=true |}]
