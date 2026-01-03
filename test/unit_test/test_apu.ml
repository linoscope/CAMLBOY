include Camlboy_lib
open Uints

(* APU register addresses *)
let nr10_addr = Uint16.of_int 0xFF10  (* Square 1 sweep *)
let nr11_addr = Uint16.of_int 0xFF11  (* Square 1 duty/length *)
let nr52_addr = Uint16.of_int 0xFF26  (* Sound on/off *)
let wave_ram_start = Uint16.of_int 0xFF30

let create () = Apu.create ()

let print t addr =
  Apu.read_byte t addr |> Uint8.show |> print_endline

let power_on t =
  Apu.write_byte t ~addr:nr52_addr ~data:(Uint8.of_int 0x80)

let power_off t =
  Apu.write_byte t ~addr:nr52_addr ~data:Uint8.zero

let%expect_test "accepts returns true for NR10-NR26" =
  let t = create () in
  let test addr =
    Printf.printf "0x%04X: %b\n" addr (Apu.accepts t (Uint16.of_int addr))
  in
  test 0xFF10;  (* NR10 *)
  test 0xFF26;  (* NR52 *)
  test 0xFF0F;  (* Not APU - IF register *)
  test 0xFF27;  (* Not APU - unused *)
  [%expect {|
    0xFF10: true
    0xFF26: true
    0xFF0F: false
    0xFF27: false |}]

let%expect_test "accepts returns true for wave RAM" =
  let t = create () in
  let test addr =
    Printf.printf "0x%04X: %b\n" addr (Apu.accepts t (Uint16.of_int addr))
  in
  test 0xFF30;  (* Wave RAM start *)
  test 0xFF3F;  (* Wave RAM end *)
  test 0xFF40;  (* Not APU - LCD control *)
  [%expect {|
    0xFF30: true
    0xFF3F: true
    0xFF40: false |}]

let%expect_test "NR52 starts powered off" =
  let t = create () in
  print t nr52_addr;
  [%expect {| $70 |}]

let%expect_test "NR52 power on sets bit 7" =
  let t = create () in
  power_on t;
  print t nr52_addr;
  [%expect {| $F0 |}]

let%expect_test "NR52 power off clears bit 7" =
  let t = create () in
  power_on t;
  power_off t;
  print t nr52_addr;
  [%expect {| $70 |}]

let%expect_test "registers cannot be written when powered off" =
  let t = create () in
  (* Write to NR11 while powered off - duty bits (7-6) should not change *)
  Apu.write_byte t ~addr:nr11_addr ~data:(Uint8.of_int 0xC0);  (* duty = 3 *)
  print t nr11_addr;
  (* NR11 reads: bits 7-6 (duty) readable, bits 5-0 read as 1 *)
  (* Default duty is Duty_50 (value 2), so bits 7-6 = 10 = 0x80 *)
  (* 0x80 | 0x3F = 0xBF *)
  [%expect {| $BF |}]

let%expect_test "registers can be written when powered on" =
  let t = create () in
  power_on t;
  Apu.write_byte t ~addr:nr11_addr ~data:(Uint8.of_int 0xC0);  (* duty = 3 *)
  print t nr11_addr;
  (* NR11 reads: bits 7-6 (duty) = 11 = 0xC0, bits 5-0 read as 1 = 0x3F *)
  (* 0xC0 | 0x3F = 0xFF *)
  [%expect {| $FF |}]

let%expect_test "power off clears all registers except wave RAM" =
  let t = create () in
  power_on t;
  Apu.write_byte t ~addr:nr11_addr ~data:(Uint8.of_int 0xC0);  (* duty = 3 *)
  Apu.write_byte t ~addr:wave_ram_start ~data:(Uint8.of_int 0xAB);
  power_off t;
  print t nr11_addr;
  print t wave_ram_start;
  (* After power off, duty resets to Duty_50 (value 2), so bits 7-6 = 10 = 0x80 *)
  (* 0x80 | 0x3F = 0xBF *)
  [%expect {|
    $BF
    $AB |}]

let%expect_test "wave RAM can be read and written" =
  let t = create () in
  (* Wave RAM can be written even when powered off *)
  Apu.write_byte t ~addr:wave_ram_start ~data:(Uint8.of_int 0x12);
  Apu.write_byte t ~addr:(Uint16.of_int 0xFF3F) ~data:(Uint8.of_int 0x34);
  print t wave_ram_start;
  print t (Uint16.of_int 0xFF3F);
  [%expect {|
    $12
    $34 |}]

let%expect_test "run does not crash" =
  let t = create () in
  power_on t;
  Apu.run t ~mcycles:100;
  print t nr52_addr;
  [%expect {| $F0 |}]

(* Integration tests for square channels *)

let nr12_addr = Uint16.of_int 0xFF12  (* Square 1 envelope *)
let nr13_addr = Uint16.of_int 0xFF13  (* Square 1 frequency low *)
let nr14_addr = Uint16.of_int 0xFF14  (* Square 1 frequency high / control *)

let%expect_test "trigger Square 1 enables channel" =
  let t = create () in
  power_on t;
  (* Set envelope to enable DAC: volume=15, direction=down *)
  Apu.write_byte t ~addr:nr12_addr ~data:(Uint8.of_int 0xF0);
  (* Trigger channel *)
  Apu.write_byte t ~addr:nr14_addr ~data:(Uint8.of_int 0x80);
  print t nr52_addr;
  (* NR52 should show channel 1 enabled (bit 0) *)
  [%expect {| $F1 |}]

let%expect_test "NR52 shows both channels when enabled" =
  let t = create () in
  power_on t;
  let nr22_addr = Uint16.of_int 0xFF17 in
  let nr24_addr = Uint16.of_int 0xFF19 in
  (* Enable Square 1 *)
  Apu.write_byte t ~addr:nr12_addr ~data:(Uint8.of_int 0xF0);
  Apu.write_byte t ~addr:nr14_addr ~data:(Uint8.of_int 0x80);
  (* Enable Square 2 *)
  Apu.write_byte t ~addr:nr22_addr ~data:(Uint8.of_int 0xF0);
  Apu.write_byte t ~addr:nr24_addr ~data:(Uint8.of_int 0x80);
  print t nr52_addr;
  (* NR52 should show channels 1 and 2 enabled (bits 0 and 1) *)
  [%expect {| $F3 |}]

let%expect_test "frequency register split across NR13 and NR14" =
  let t = create () in
  power_on t;
  (* Set frequency to 0x456 = 0100_0101_0110
     NR13 = 0x56 (low 8 bits)
     NR14 bits 2-0 = 0x4 (high 3 bits) *)
  Apu.write_byte t ~addr:nr13_addr ~data:(Uint8.of_int 0x56);
  Apu.write_byte t ~addr:nr14_addr ~data:(Uint8.of_int 0x04);
  (* NR13 is write-only, reads as 0xFF *)
  print t nr13_addr;
  (* NR14 bits 2-0 are write-only, reads as 0xBF (bit 6 = length enable = 0) *)
  print t nr14_addr;
  [%expect {|
    $FF
    $BF |}]

let%expect_test "sweep register NR10 read/write" =
  let t = create () in
  power_on t;
  (* Set sweep: period=5, negate=true, shift=3 = 0101_1011 = 0x5B *)
  Apu.write_byte t ~addr:nr10_addr ~data:(Uint8.of_int 0x5B);
  print t nr10_addr;
  (* NR10 reads: bit 7 unused (reads as 1), bits 6-4 period, bit 3 negate, bits 2-0 shift *)
  (* 0x80 | 0x50 | 0x08 | 0x03 = 0xDB *)
  [%expect {| $DB |}]

let%expect_test "length counter disables channel" =
  let t = create () in
  power_on t;
  (* Set envelope to enable DAC *)
  Apu.write_byte t ~addr:nr12_addr ~data:(Uint8.of_int 0xF0);
  (* Set length to 1 (register value 63 means length = 64 - 63 = 1) *)
  Apu.write_byte t ~addr:nr11_addr ~data:(Uint8.of_int 0x3F);
  (* Trigger with length enable *)
  Apu.write_byte t ~addr:nr14_addr ~data:(Uint8.of_int 0xC0);
  print t nr52_addr;
  (* Run enough cycles for length to expire (1 tick at 256Hz = 4096 mcycles) *)
  (* Frame sequencer clocks length at steps 0,2,4,6, so we need to hit one *)
  Apu.run t ~mcycles:2048;  (* One frame sequencer step *)
  print t nr52_addr;
  [%expect {|
    $F1
    $F0 |}]

(* Audio buffer integration tests *)

let%expect_test "sample generation rate" =
  (* Create APU with known sample rate for predictable timing *)
  (* At 44100 Hz and 1048576 M-cycles/sec, we get ~23.78 M-cycles per sample *)
  let t = Apu.create ~sample_rate:44100 () in
  Printf.printf "initial samples: %d\n" (Apu.samples_available t);
  (* Run for ~100 M-cycles - should generate ~4 samples (100 / 23.78 ≈ 4.2) *)
  Apu.run t ~mcycles:100;
  Printf.printf "after 100 mcycles: %d\n" (Apu.samples_available t);
  (* Run for ~1000 M-cycles - should generate ~42 more samples *)
  Apu.run t ~mcycles:1000;
  Printf.printf "after 1100 mcycles: %d\n" (Apu.samples_available t);
  [%expect {|
    initial samples: 0
    after 100 mcycles: 4
    after 1100 mcycles: 46 |}]

let%expect_test "samples can be popped" =
  let t = Apu.create ~sample_rate:44100 () in
  Apu.run t ~mcycles:100;
  let count = Apu.samples_available t in
  Printf.printf "available: %d\n" count;
  (* Pop one sample *)
  (match Apu.pop_sample t with
   | Some s -> Printf.printf "got sample: left=%d, right=%d\n" s.left s.right
   | None -> print_endline "empty");
  Printf.printf "after pop: %d\n" (Apu.samples_available t);
  [%expect {|
    available: 4
    got sample: left=-32768, right=-32768
    after pop: 3 |}]

let%expect_test "pop_samples batch read" =
  let t = Apu.create ~sample_rate:44100 () in
  Apu.run t ~mcycles:100;
  let dst = Bigarray.(Array1.create int16_signed c_layout (10 * 2)) in
  let count = Apu.pop_samples t ~dst ~count:10 in
  Printf.printf "requested: 10, got: %d\n" count;
  Printf.printf "remaining: %d\n" (Apu.samples_available t);
  [%expect {|
    requested: 10, got: 4
    remaining: 0 |}]
