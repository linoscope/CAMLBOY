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
  (* Write to NR11 while powered off *)
  Apu.write_byte t ~addr:nr11_addr ~data:(Uint8.of_int 0x80);
  print t nr11_addr;
  [%expect {| $00 |}]

let%expect_test "registers can be written when powered on" =
  let t = create () in
  power_on t;
  Apu.write_byte t ~addr:nr11_addr ~data:(Uint8.of_int 0x80);
  print t nr11_addr;
  [%expect {| $80 |}]

let%expect_test "power off clears all registers except wave RAM" =
  let t = create () in
  power_on t;
  Apu.write_byte t ~addr:nr11_addr ~data:(Uint8.of_int 0x80);
  Apu.write_byte t ~addr:wave_ram_start ~data:(Uint8.of_int 0xAB);
  power_off t;
  print t nr11_addr;
  print t wave_ram_start;
  [%expect {|
    $00
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
