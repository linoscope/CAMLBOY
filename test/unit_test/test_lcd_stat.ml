include Camlboy_lib
open Uints

let addr = (Uint16.of_int 0xFF41)

let%expect_test "test read value" =
  let t = Lcd_stat.create ~addr in

  Lcd_stat.read_byte t addr
  |> Uint8.show
  |> print_endline;

  [%expect {| $82 |}]

let%expect_test "test byte value for each mode" =
  let t = Lcd_stat.create ~addr in

  Gpu_mode.[HBlank; VBlank; OAM_search; Pixel_transfer]
  |> List.iter (fun mode ->
      Lcd_stat.set_gpu_mode t mode;
      Lcd_stat.read_byte t addr |> Uint8.show |> print_endline;
    );

  [%expect {|
    $80
    $81
    $82
    $83 |}]

let%expect_test "test set_lyc_eq_ly_flag" =
  let t = Lcd_stat.create ~addr in

  Lcd_stat.set_lyc_eq_ly_flag t true;
  Lcd_stat.read_byte t addr |> Uint8.show |> print_endline;

  [%expect {| $86 |}];

  Lcd_stat.get_lyc_eq_ly_flag t |> Printf.printf "%b";

  [%expect {| true |}]

let%expect_test "test write enables int flags" =
  let t = Lcd_stat.create ~addr in

  Lcd_stat.write_byte t ~addr ~data:(Uint8.of_int 0xFF);

  Lcd_stat.[LYC_eq_LY; OAM; VBlank; HBlank]
  |> List.map (Lcd_stat.is_enabled t)
  |> List.iter (Printf.printf "%b ");
  [%expect {| true true true true |}]


let%expect_test "test set_gpu_mode" =
  let t = Lcd_stat.create ~addr in

  Lcd_stat.set_gpu_mode t Pixel_transfer;

  Lcd_stat.get_gpu_mode t = Pixel_transfer
  |> Printf.printf "%b";
  [%expect {| true |}]
