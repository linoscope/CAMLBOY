include Camlboy_lib
open Uints

let create_wave_ram () =
  (* Create wave RAM with a simple pattern: 0x01, 0x23, 0x45, ... *)
  let ram = Array.make 16 Uint8.zero in
  for i = 0 to 15 do
    ram.(i) <- Uint8.of_int ((i * 2) lor ((i * 2 + 1) lsl 4))
  done;
  ram

let%expect_test "initial state is disabled" =
  let ch = Wave_channel.create () in
  Printf.printf "enabled: %b, dac: %b\n"
    (Wave_channel.is_enabled ch)
    (Wave_channel.get_dac_enabled ch);
  [%expect {| enabled: false, dac: false |}]

let%expect_test "set DAC enabled" =
  let ch = Wave_channel.create () in
  Wave_channel.set_dac_enabled ch true;
  Printf.printf "dac: %b\n" (Wave_channel.get_dac_enabled ch);
  Wave_channel.set_dac_enabled ch false;
  Printf.printf "dac: %b\n" (Wave_channel.get_dac_enabled ch);
  [%expect {|
    dac: true
    dac: false |}]

let%expect_test "trigger enables channel when DAC on" =
  let ch = Wave_channel.create () in
  let wave_ram = create_wave_ram () in
  Wave_channel.set_dac_enabled ch true;
  Wave_channel.trigger ch ~wave_ram ~next_step_clocks_length:true;
  Printf.printf "enabled: %b\n" (Wave_channel.is_enabled ch);
  [%expect {| enabled: true |}]

let%expect_test "trigger does not enable channel when DAC off" =
  let ch = Wave_channel.create () in
  let wave_ram = create_wave_ram () in
  Wave_channel.trigger ch ~wave_ram ~next_step_clocks_length:true;
  Printf.printf "enabled: %b\n" (Wave_channel.is_enabled ch);
  [%expect {| enabled: false |}]

let%expect_test "disabling DAC disables channel" =
  let ch = Wave_channel.create () in
  let wave_ram = create_wave_ram () in
  Wave_channel.set_dac_enabled ch true;
  Wave_channel.trigger ch ~wave_ram ~next_step_clocks_length:true;
  Printf.printf "before: %b\n" (Wave_channel.is_enabled ch);
  Wave_channel.set_dac_enabled ch false;
  Printf.printf "after: %b\n" (Wave_channel.is_enabled ch);
  [%expect {|
    before: true
    after: false |}]

let%expect_test "volume codes" =
  let ch = Wave_channel.create () in
  (* Fill all wave RAM with 0xFF so every sample is 0xF *)
  let wave_ram = Array.make 16 (Uint8.of_int 0xFF) in
  Wave_channel.set_dac_enabled ch true;
  Wave_channel.set_frequency ch 2046;  (* period = 1 M-cycle *)
  Wave_channel.trigger ch ~wave_ram ~next_step_clocks_length:true;
  (* Advance once to load sample 0xF into buffer *)
  Wave_channel.run ch ~wave_ram ~mcycles:1;

  (* Volume code 0 = mute (shift 4) *)
  Wave_channel.set_volume_code ch 0;
  Printf.printf "vol 0 (mute): %d\n" (Wave_channel.get_sample ch);

  (* Volume code 1 = 100% (no shift) *)
  Wave_channel.set_volume_code ch 1;
  Printf.printf "vol 1 (100%%): %d\n" (Wave_channel.get_sample ch);

  (* Volume code 2 = 50% (shift 1) *)
  Wave_channel.set_volume_code ch 2;
  Printf.printf "vol 2 (50%%): %d\n" (Wave_channel.get_sample ch);

  (* Volume code 3 = 25% (shift 2) *)
  Wave_channel.set_volume_code ch 3;
  Printf.printf "vol 3 (25%%): %d\n" (Wave_channel.get_sample ch);

  [%expect {|
    vol 0 (mute): 0
    vol 1 (100%): 15
    vol 2 (50%): 7
    vol 3 (25%): 3 |}]

let%expect_test "sample position advances" =
  let ch = Wave_channel.create () in
  let wave_ram = Array.make 16 Uint8.zero in
  (* Fill wave RAM with distinct values *)
  for i = 0 to 15 do
    wave_ram.(i) <- Uint8.of_int ((i * 16) lor i)  (* 0x00, 0x11, 0x22, ... *)
  done;

  Wave_channel.set_dac_enabled ch true;
  Wave_channel.set_volume_code ch 1;  (* 100% volume *)
  (* Use a lower frequency for predictable timing *)
  (* freq 2044: period = (2048 - 2044) / 2 = 2 M-cycles per position advance *)
  Wave_channel.set_frequency ch 2044;
  Wave_channel.trigger ch ~wave_ram ~next_step_clocks_length:true;

  Printf.printf "position 0: %d\n" (Wave_channel.get_sample ch);

  (* Run 2 M-cycles - should advance one position *)
  Wave_channel.run ch ~wave_ram ~mcycles:2;
  Printf.printf "position 1: %d\n" (Wave_channel.get_sample ch);

  (* Run 4 more M-cycles - should advance two positions (to position 3) *)
  Wave_channel.run ch ~wave_ram ~mcycles:4;
  Printf.printf "position 3: %d\n" (Wave_channel.get_sample ch);

  [%expect {|
    position 0: 0
    position 1: 0
    position 3: 1 |}]

let%expect_test "length counter disables channel" =
  let ch = Wave_channel.create () in
  let wave_ram = create_wave_ram () in
  let len = Wave_channel.get_length ch in

  Wave_channel.set_dac_enabled ch true;
  Length_counter.load_from_register len ~register_value:255;  (* length = 1 *)
  Length_counter.set_enabled len true;
  Wave_channel.trigger ch ~wave_ram ~next_step_clocks_length:true;

  Printf.printf "before: %b\n" (Wave_channel.is_enabled ch);
  Wave_channel.clock_length ch;  (* Should expire *)
  Printf.printf "after: %b\n" (Wave_channel.is_enabled ch);

  [%expect {|
    before: true
    after: false |}]

(* Obscure behavior: triggering keeps the previous sample_buffer value.
   Reference: https://gbdev.gg8.se/wiki/articles/Gameboy_sound_hardware#Trigger_Event *)
let%expect_test "trigger keeps previous sample_buffer (obscure behavior)" =
  let ch = Wave_channel.create () in
  let wave_ram = Array.make 16 Uint8.zero in
  (* Fill wave RAM: byte 0 = 0x12 (samples 1,2), byte 1 = 0x34 (samples 3,4), etc. *)
  wave_ram.(0) <- Uint8.of_int 0x12;
  wave_ram.(1) <- Uint8.of_int 0x34;

  Wave_channel.set_dac_enabled ch true;
  Wave_channel.set_volume_code ch 1;  (* 100% volume *)
  Wave_channel.set_frequency ch 2044;  (* period = 2 M-cycles *)
  Wave_channel.trigger ch ~wave_ram ~next_step_clocks_length:true;

  (* Initially sample_buffer is 0 (from create), trigger should NOT update it *)
  Printf.printf "after trigger: %d\n" (Wave_channel.get_sample ch);

  (* Advance to load sample at position 1 (low nibble of byte 0 = 2) *)
  Wave_channel.run ch ~wave_ram ~mcycles:2;
  Printf.printf "after first advance: %d\n" (Wave_channel.get_sample ch);

  (* Now re-trigger - sample_buffer should keep the value 2 *)
  Wave_channel.trigger ch ~wave_ram ~next_step_clocks_length:true;
  Printf.printf "after re-trigger: %d\n" (Wave_channel.get_sample ch);

  (* Advance again - now should read position 1 again = 2 *)
  Wave_channel.run ch ~wave_ram ~mcycles:2;
  Printf.printf "after advance post-retrigger: %d\n" (Wave_channel.get_sample ch);

  [%expect {|
    after trigger: 0
    after first advance: 2
    after re-trigger: 2
    after advance post-retrigger: 2 |}]

let%expect_test "reset clears all state" =
  let ch = Wave_channel.create () in
  let wave_ram = create_wave_ram () in

  Wave_channel.set_dac_enabled ch true;
  Wave_channel.set_volume_code ch 2;
  Wave_channel.set_frequency ch 1000;
  Wave_channel.trigger ch ~wave_ram ~next_step_clocks_length:true;

  Wave_channel.reset ch;

  Printf.printf "enabled: %b, dac: %b, vol: %d, freq: %d\n"
    (Wave_channel.is_enabled ch)
    (Wave_channel.get_dac_enabled ch)
    (Wave_channel.get_volume_code ch)
    (Wave_channel.get_frequency ch);

  [%expect {| enabled: false, dac: false, vol: 0, freq: 0 |}]
