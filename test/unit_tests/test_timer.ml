include Camlboy_lib
open Uints

let div_addr = Uint16.(of_int 0xFF04)
let tima_addr = Uint16.(of_int 0xFF05)
let tma_addr = Uint16.(of_int 0xFF06)
let tac_addr = Uint16.(of_int 0xFF07)

let ic = Interrupt_controller.create
    ~ie_addr:Uint16.(of_int 0xFFFF)
    ~if_addr:Uint16.(of_int 0xFF0F)

let create () =
  Timer.create
    ~div_addr
    ~tima_addr
    ~tma_addr
    ~tac_addr
    ~ic

let set_tima t bits =
  Timer.write_byte t ~addr:tac_addr ~data:Uint8.(of_int bits)

let print t addr =
  Timer.read_byte t addr |> Uint8.show |> print_endline

let print_before_and_after_mcycles t addr mcycles =
  Timer.run t ~mcycles:(mcycles - 1);
  print t addr;
  Timer.run t ~mcycles:1;
  print t addr

let%expect_test "div increments after 4 * 16 = 64 mcycles" =
  let t = create () in

  print_before_and_after_mcycles t div_addr 64;

  [%expect {|
    $00
    $01 |}]

let%expect_test "div resets when overflow" =
  let t = create () in

  print_before_and_after_mcycles t div_addr (0x100 * 64);

  [%expect {|
    $FF
    $00 |}]

let%expect_test "div resets on write" =
  let t = create () in

  Timer.run t ~mcycles:128;
  print t div_addr;
  Timer.write_byte t ~addr:div_addr ~data:Uint8.zero;
  print t div_addr;

  [%expect {|
    $02
    $00 |}]

let%expect_test "when tma is disabled than tima is not incremented" =
  let t = create () in

  set_tima t 0b000;
  print_before_and_after_mcycles t tima_addr 256;

  [%expect {|
    $00
    $00 |}]

let%expect_test "when tma=0b100 then tima increments after 256 mcycles" =
  let t = create () in

  set_tima t 0b100;
  print_before_and_after_mcycles t tima_addr 256;

  [%expect {|
    $00
    $01 |}]

let%expect_test "when tma=0b101 then tima increments after 4 mcycles" =
  let t = create () in

  set_tima t 0b101;
  print_before_and_after_mcycles t tima_addr 4;

  [%expect {|
    $00
    $01 |}]

let%expect_test "when tma=0b110 then tima increments after 16 mcycles" =
  let t = create () in

  set_tima t 0b110;
  print_before_and_after_mcycles t tima_addr 16;

  [%expect {|
    $00
    $01 |}]

let%expect_test "when tma=0b111 then tima increments after 64 mcycles" =
  let t = create () in

  set_tima t 0b111;
  print_before_and_after_mcycles t tima_addr 64;

  [%expect {|
    $00
    $01 |}]

let%expect_test "when tma changed while running then internal mcycles is carried over" =
  let t = create () in

  set_tima t 0b101;
  Timer.run t ~mcycles:15;
  print t tima_addr;
  set_tima t 0b110;
  Timer.run t ~mcycles:1;
  print t tima_addr;

  [%expect {|
    $03
    $04 |}]

let%expect_test "when tima overflows then resets to tma" =
  let t = create () in

  set_tima t 0b100;
  Timer.write_byte t ~addr:tma_addr ~data:Uint8.(of_int 0xF0);
  Timer.run t ~mcycles:(0x100 * 256);
  print t tima_addr;
  Timer.run t ~mcycles:1;
  print t tima_addr;

  [%expect {|
    $00
    $00 |}]
