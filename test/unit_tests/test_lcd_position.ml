open Camlboy_lib
open Uints

let scy_addr = Uint16.of_int 0xFF42
let scx_addr = Uint16.of_int 0xFF43
let ly_addr  = Uint16.of_int 0xFF44
let lyc_addr = Uint16.of_int 0xFF45
let wy_addr  = Uint16.of_int 0xFF4A
let wx_addr  = Uint16.of_int 0xFF4B

let create () = Lcd_position.create ~scy_addr ~scx_addr ~ly_addr ~lyc_addr ~wy_addr ~wx_addr

let%expect_test "test read initial values" =
  let t = create () in

  [scy_addr; scx_addr; ly_addr; lyc_addr; wy_addr; wx_addr]
  |> List.map (Lcd_position.read_byte t)
  |> List.map Uint8.show
  |> List.iter print_endline;

  [%expect {|
    $00
    $00
    $00
    $00
    $00
    $00 |}]

let%expect_test "test write to ly is ignored" =
  let t = create () in

  Lcd_position.write_byte t ~addr:scy_addr ~data:(Uint8.of_int 0xAA);
  Lcd_position.write_byte t ~addr:scx_addr ~data:(Uint8.of_int 0xBB);
  Lcd_position.write_byte t ~addr:ly_addr  ~data:(Uint8.of_int 0xCC);
  Lcd_position.write_byte t ~addr:lyc_addr ~data:(Uint8.of_int 0xDD);
  Lcd_position.write_byte t ~addr:wy_addr  ~data:(Uint8.of_int 0xEE);
  Lcd_position.write_byte t ~addr:wx_addr  ~data:(Uint8.of_int 0xFF);

  [scy_addr; scx_addr; ly_addr; lyc_addr; wy_addr; wx_addr]
  |> List.map (Lcd_position.read_byte t)
  |> List.map Uint8.show
  |> List.iter print_endline;

  [%expect {|
    $AA
    $BB
    $00
    $DD
    $EE
    $FF |}]

let%expect_test "test get functions" =
  let t = create () in

  Lcd_position.write_byte t ~addr:scy_addr ~data:(Uint8.of_int 0x01);
  Lcd_position.write_byte t ~addr:scx_addr ~data:(Uint8.of_int 0x02);
  Lcd_position.write_byte t ~addr:ly_addr  ~data:(Uint8.of_int 0x03);
  Lcd_position.write_byte t ~addr:lyc_addr ~data:(Uint8.of_int 0x04);
  Lcd_position.write_byte t ~addr:wy_addr  ~data:(Uint8.of_int 0x05);
  Lcd_position.write_byte t ~addr:wx_addr  ~data:(Uint8.of_int 0x06);

  Lcd_position.[get_scy t; get_scx t; get_ly t; get_lyc t; get_wy t; get_wx t]
  |> List.iter (Printf.printf "%d ");

  [%expect {|
    1 2 0 4 5 6 |}]

let%expect_test "test set ly" =
  let t = create () in

  Lcd_position.set_ly t 10;

  Lcd_position.get_ly t |> print_int;

  [%expect {| 10 |}]
