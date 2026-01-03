include Camlboy_lib

let show_duty = function
  | Square_channel.Duty_12_5 -> "12.5%"
  | Square_channel.Duty_25 -> "25%"
  | Square_channel.Duty_50 -> "50%"
  | Square_channel.Duty_75 -> "75%"

let%expect_test "create without sweep" =
  let ch = Square_channel.create ~has_sweep:false in
  Printf.printf "enabled: %b, has_sweep: %b\n"
    (Square_channel.is_enabled ch)
    (Square_channel.has_sweep ch);
  [%expect {| enabled: false, has_sweep: false |}]

let%expect_test "create with sweep" =
  let ch = Square_channel.create ~has_sweep:true in
  Printf.printf "has_sweep: %b\n" (Square_channel.has_sweep ch);
  [%expect {| has_sweep: true |}]

let%expect_test "duty cycle conversion" =
  Printf.printf "0 -> %s\n" (show_duty (Square_channel.duty_of_int 0));
  Printf.printf "1 -> %s\n" (show_duty (Square_channel.duty_of_int 1));
  Printf.printf "2 -> %s\n" (show_duty (Square_channel.duty_of_int 2));
  Printf.printf "3 -> %s\n" (show_duty (Square_channel.duty_of_int 3));
  [%expect {|
    0 -> 12.5%
    1 -> 25%
    2 -> 50%
    3 -> 75% |}]

let%expect_test "get_sample returns 0 when disabled" =
  let ch = Square_channel.create ~has_sweep:false in
  Printf.printf "sample: %d\n" (Square_channel.get_sample ch);
  [%expect {| sample: 0 |}]

let%expect_test "trigger enables channel when DAC enabled" =
  let ch = Square_channel.create ~has_sweep:false in
  let env = Square_channel.get_envelope ch in
  (* Set up envelope with volume > 0 to enable DAC *)
  Envelope.set_volume env 8;
  Square_channel.update_dac ch;
  Square_channel.trigger ch;
  Printf.printf "enabled: %b\n" (Square_channel.is_enabled ch);
  [%expect {| enabled: true |}]

let%expect_test "trigger does not enable when DAC disabled" =
  let ch = Square_channel.create ~has_sweep:false in
  (* DAC is disabled when volume=0 and direction=down *)
  Square_channel.trigger ch;
  Printf.printf "enabled: %b\n" (Square_channel.is_enabled ch);
  [%expect {| enabled: false |}]

let%expect_test "get_sample uses envelope volume" =
  let ch = Square_channel.create ~has_sweep:false in
  let env = Square_channel.get_envelope ch in
  Envelope.set_volume env 10;
  Square_channel.update_dac ch;
  Square_channel.trigger ch;
  (* Duty 50% starts with waveform[0] = 1, so sample = 1 * volume *)
  Square_channel.set_duty ch Square_channel.Duty_50;
  Printf.printf "sample: %d\n" (Square_channel.get_sample ch);
  [%expect {| sample: 10 |}]

let%expect_test "run advances duty position" =
  let ch = Square_channel.create ~has_sweep:false in
  let env = Square_channel.get_envelope ch in
  Envelope.set_volume env 15;
  Square_channel.update_dac ch;
  (* Frequency 2047 gives timer period = 2048 - 2047 = 1 mcycle *)
  Square_channel.set_frequency ch 2047;
  Square_channel.trigger ch;
  Square_channel.set_duty ch Square_channel.Duty_25;
  (* Duty_25 = [1,0,0,0,0,0,0,1] *)
  Printf.printf "pos 0: sample=%d\n" (Square_channel.get_sample ch);
  Square_channel.run ch ~mcycles:1;
  Printf.printf "pos 1: sample=%d\n" (Square_channel.get_sample ch);
  Square_channel.run ch ~mcycles:1;
  Printf.printf "pos 2: sample=%d\n" (Square_channel.get_sample ch);
  [%expect {|
    pos 0: sample=15
    pos 1: sample=0
    pos 2: sample=0 |}]

let%expect_test "timer period depends on frequency" =
  let ch = Square_channel.create ~has_sweep:false in
  let env = Square_channel.get_envelope ch in
  Envelope.set_volume env 15;
  Square_channel.update_dac ch;
  (* Frequency 2044 gives timer period = 2048 - 2044 = 4 mcycles *)
  Square_channel.set_frequency ch 2044;
  Square_channel.trigger ch;
  (* After 3 mcycles, position should still be 0 *)
  Square_channel.run ch ~mcycles:3;
  Printf.printf "after 3: sample=%d\n" (Square_channel.get_sample ch);
  (* After 1 more mcycle (total 4), position should advance *)
  Square_channel.run ch ~mcycles:1;
  Printf.printf "after 4: sample=%d\n" (Square_channel.get_sample ch);
  [%expect {|
    after 3: sample=15
    after 4: sample=0 |}]

let%expect_test "clock_length can disable channel" =
  let ch = Square_channel.create ~has_sweep:false in
  let env = Square_channel.get_envelope ch in
  Envelope.set_volume env 10;
  Square_channel.update_dac ch;
  let len = Square_channel.get_length ch in
  Length_counter.set_length len 1;
  Length_counter.set_enabled len true;
  Square_channel.trigger ch;
  Printf.printf "before clock: enabled=%b\n" (Square_channel.is_enabled ch);
  Square_channel.clock_length ch;
  Printf.printf "after clock: enabled=%b\n" (Square_channel.is_enabled ch);
  [%expect {|
    before clock: enabled=true
    after clock: enabled=false |}]

let%expect_test "clock_envelope changes volume" =
  let ch = Square_channel.create ~has_sweep:false in
  let env = Square_channel.get_envelope ch in
  Envelope.set_volume env 10;
  Envelope.set_period env 1;
  Envelope.set_direction env Envelope.Down;
  Square_channel.update_dac ch;
  Square_channel.trigger ch;
  let sample1 = Square_channel.get_sample ch in
  Square_channel.clock_envelope ch;
  let sample2 = Square_channel.get_sample ch in
  Printf.printf "before: %d, after: %d\n" sample1 sample2;
  [%expect {| before: 10, after: 9 |}]

let%expect_test "frequency is 11-bit clamped" =
  let ch = Square_channel.create ~has_sweep:false in
  Square_channel.set_frequency ch 0x800;  (* Over 11 bits *)
  Printf.printf "frequency: %d\n" (Square_channel.get_frequency ch);
  [%expect {| frequency: 0 |}]

let%expect_test "reset clears all state" =
  let ch = Square_channel.create ~has_sweep:false in
  let env = Square_channel.get_envelope ch in
  Envelope.set_volume env 10;
  Square_channel.update_dac ch;
  Square_channel.set_frequency ch 1000;
  Square_channel.set_duty ch Square_channel.Duty_75;
  Square_channel.trigger ch;
  Square_channel.reset ch;
  Printf.printf "enabled: %b, freq: %d, duty: %s\n"
    (Square_channel.is_enabled ch)
    (Square_channel.get_frequency ch)
    (show_duty (Square_channel.get_duty ch));
  [%expect {| enabled: false, freq: 0, duty: 50% |}]

let%expect_test "full duty cycle for 12.5%" =
  let ch = Square_channel.create ~has_sweep:false in
  let env = Square_channel.get_envelope ch in
  Envelope.set_volume env 1;
  Square_channel.update_dac ch;
  Square_channel.set_frequency ch 2047;
  Square_channel.set_duty ch Square_channel.Duty_12_5;
  Square_channel.trigger ch;
  let samples = Array.init 8 (fun _ ->
      let s = Square_channel.get_sample ch in
      Square_channel.run ch ~mcycles:1;
      s)
  in
  Printf.printf "samples: %s\n"
    (Array.to_list samples |> List.map string_of_int |> String.concat ",");
  (* Duty_12_5 = [0,0,0,0,0,0,0,1] *)
  [%expect {| samples: 0,0,0,0,0,0,0,1 |}]
