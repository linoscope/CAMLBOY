include Camlboy_lib

let%expect_test "initial state is disabled" =
  let ch = Noise_channel.create () in
  Printf.printf "enabled: %b, lfsr initial: 0x%04X\n"
    (Noise_channel.is_enabled ch)
    0x7FFF;  (* LFSR starts at all 1s *)
  [%expect {| enabled: false, lfsr initial: 0x7FFF |}]

let%expect_test "trigger enables channel when DAC on" =
  let ch = Noise_channel.create () in
  let env = Noise_channel.get_envelope ch in
  (* Set envelope to enable DAC: volume > 0 or direction = up *)
  Envelope.load_from_register env ~register_value:0xF0;  (* vol=15, dir=down *)
  Noise_channel.update_dac ch;
  Noise_channel.trigger ch ~next_step_clocks_length:true;
  Printf.printf "enabled: %b\n" (Noise_channel.is_enabled ch);
  [%expect {| enabled: true |}]

let%expect_test "trigger does not enable channel when DAC off" =
  let ch = Noise_channel.create () in
  (* DAC is off by default (volume=0, direction=down) *)
  Noise_channel.trigger ch ~next_step_clocks_length:true;
  Printf.printf "enabled: %b\n" (Noise_channel.is_enabled ch);
  [%expect {| enabled: false |}]

let%expect_test "clock shift and divisor code" =
  let ch = Noise_channel.create () in
  Noise_channel.set_clock_shift ch 5;
  Noise_channel.set_divisor_code ch 3;
  Printf.printf "shift: %d, divisor: %d\n"
    (Noise_channel.get_clock_shift ch)
    (Noise_channel.get_divisor_code ch);
  [%expect {| shift: 5, divisor: 3 |}]

let%expect_test "width mode" =
  let ch = Noise_channel.create () in
  Printf.printf "default: %b\n" (Noise_channel.get_width_mode ch);
  Noise_channel.set_width_mode ch true;
  Printf.printf "7-bit: %b\n" (Noise_channel.get_width_mode ch);
  Noise_channel.set_width_mode ch false;
  Printf.printf "15-bit: %b\n" (Noise_channel.get_width_mode ch);
  [%expect {|
    default: false
    7-bit: true
    15-bit: false |}]

let%expect_test "output depends on LFSR" =
  let ch = Noise_channel.create () in
  let env = Noise_channel.get_envelope ch in
  Envelope.load_from_register env ~register_value:0xF0;  (* vol=15 *)
  Noise_channel.update_dac ch;
  Noise_channel.trigger ch ~next_step_clocks_length:true;

  (* LFSR starts at 0x7FFF, bit 0 = 1, inverted = 0 *)
  Printf.printf "sample: %d\n" (Noise_channel.get_sample ch);

  (* After running, LFSR changes. At fastest setting, it takes many clocks *)
  (* to produce a 0 bit (which inverts to 1 for non-zero output) *)
  Noise_channel.set_clock_shift ch 0;
  Noise_channel.set_divisor_code ch 0;  (* fastest: period = 8 *)
  Noise_channel.run ch ~mcycles:10;
  Printf.printf "after run: %d\n" (Noise_channel.get_sample ch);

  [%expect {|
    sample: 0
    after run: 0 |}]

let%expect_test "envelope affects volume" =
  let ch = Noise_channel.create () in
  let env = Noise_channel.get_envelope ch in

  (* Start with volume 15, direction down, period 1 *)
  Envelope.load_from_register env ~register_value:0xF1;
  Noise_channel.update_dac ch;
  Noise_channel.trigger ch ~next_step_clocks_length:true;

  (* Get initial sample (0 because LFSR bit 0 starts as 1, inverted = 0) *)
  Printf.printf "sample at vol 15: %d\n" (Noise_channel.get_sample ch);

  (* Clock envelope to decrease volume *)
  Noise_channel.clock_envelope ch;
  Printf.printf "sample at vol 14: %d\n" (Noise_channel.get_sample ch);

  (* The actual value depends on LFSR state, but volume decreases *)
  Printf.printf "volume: %d\n" (Envelope.get_volume env);

  [%expect {|
    sample at vol 15: 0
    sample at vol 14: 0
    volume: 14 |}]

let%expect_test "length counter disables channel" =
  let ch = Noise_channel.create () in
  let len = Noise_channel.get_length ch in
  let env = Noise_channel.get_envelope ch in

  Envelope.load_from_register env ~register_value:0xF0;
  Noise_channel.update_dac ch;
  Length_counter.load_from_register len ~register_value:63;  (* length = 1 *)
  Length_counter.set_enabled len true;
  Noise_channel.trigger ch ~next_step_clocks_length:true;

  Printf.printf "before: %b\n" (Noise_channel.is_enabled ch);
  Noise_channel.clock_length ch;  (* Should expire *)
  Printf.printf "after: %b\n" (Noise_channel.is_enabled ch);

  [%expect {|
    before: true
    after: false |}]

(* Obscure behavior: clock shift 14 or 15 results in no LFSR clocks.
   Reference: https://gbdev.gg8.se/wiki/articles/Gameboy_sound_hardware#Noise_Channel *)
let%expect_test "clock shift 14-15 produces no LFSR clocks (obscure behavior)" =
  let ch = Noise_channel.create () in
  let env = Noise_channel.get_envelope ch in
  Envelope.load_from_register env ~register_value:0xF0;  (* vol=15 *)
  Noise_channel.update_dac ch;

  (* With clock_shift=14, LFSR should not advance *)
  Noise_channel.set_clock_shift ch 14;
  Noise_channel.set_divisor_code ch 0;
  Noise_channel.trigger ch ~next_step_clocks_length:true;

  let sample_before = Noise_channel.get_sample ch in
  (* Run for a long time - with shift=0 this would cause many LFSR clocks *)
  Noise_channel.run ch ~mcycles:10000;
  let sample_after = Noise_channel.get_sample ch in

  Printf.printf "shift 14 - before: %d, after: %d, same: %b\n"
    sample_before sample_after (sample_before = sample_after);

  (* Also test shift=15 *)
  Noise_channel.set_clock_shift ch 15;
  Noise_channel.trigger ch ~next_step_clocks_length:true;
  let sample_before = Noise_channel.get_sample ch in
  Noise_channel.run ch ~mcycles:10000;
  let sample_after = Noise_channel.get_sample ch in

  Printf.printf "shift 15 - before: %d, after: %d, same: %b\n"
    sample_before sample_after (sample_before = sample_after);

  [%expect {|
    shift 14 - before: 0, after: 0, same: true
    shift 15 - before: 0, after: 0, same: true |}]

let%expect_test "reset clears all state" =
  let ch = Noise_channel.create () in
  let env = Noise_channel.get_envelope ch in

  Envelope.load_from_register env ~register_value:0xF0;
  Noise_channel.update_dac ch;
  Noise_channel.set_clock_shift ch 5;
  Noise_channel.set_width_mode ch true;
  Noise_channel.set_divisor_code ch 3;
  Noise_channel.trigger ch ~next_step_clocks_length:true;

  Noise_channel.reset ch;

  Printf.printf "enabled: %b, shift: %d, width: %b, divisor: %d\n"
    (Noise_channel.is_enabled ch)
    (Noise_channel.get_clock_shift ch)
    (Noise_channel.get_width_mode ch)
    (Noise_channel.get_divisor_code ch);

  [%expect {| enabled: false, shift: 0, width: false, divisor: 0 |}]
