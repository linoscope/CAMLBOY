open Camlboy_lib
open Uints

let ie_addr = Uint16.(of_int 0xFF)
let if_addr = Uint16.(of_int 0xF0)

let create () =
  Interrupt_controller.create ~ie_addr ~if_addr

let%expect_test "create" =
  let t = create () in

  t |> Interrupt_controller.show |> Printf.printf "%s";
  [%expect {| ie:(vblank:1, lcd_stat:1, timer:1, serial_port:1, joypad:1), if:(vblank:0, lcd_stat:0, timer:0, serial_port:0, joypad:0) |}]


let%expect_test "request" =
  let t = create () in

  Interrupt_controller.request t VBlank;
  Interrupt_controller.request t Timer;

  t |> Interrupt_controller.show |> Printf.printf "%s";
  [%expect {| ie:(vblank:1, lcd_stat:1, timer:1, serial_port:1, joypad:1), if:(vblank:1, lcd_stat:0, timer:1, serial_port:0, joypad:0) |}]

let%expect_test "clear" =
  let t = create () in

  Interrupt_controller.request t VBlank;
  Interrupt_controller.clear t VBlank;

  t |> Interrupt_controller.show |> Printf.printf "%s";
  [%expect {| ie:(vblank:1, lcd_stat:1, timer:1, serial_port:1, joypad:1), if:(vblank:0, lcd_stat:0, timer:0, serial_port:0, joypad:0) |}]

let%expect_test "next returns None when nothing is requested" =
  let t = create () in

  begin match t |> Interrupt_controller.next with
    | None -> Printf.printf "None"
    | Some type_ -> type_ |> Interrupt_controller.show_type_ |> Printf.printf "%s"
  end;
  [%expect {| None |}]

let%expect_test "next returns enabled, requested, and highest priority" =
  let t = create () in

  Interrupt_controller.request t VBlank;
  Interrupt_controller.request t Timer;

  begin match t |> Interrupt_controller.next with
    | None -> Printf.printf "None"
    | Some type_ -> type_ |> Interrupt_controller.show_type_ |> Printf.printf "%s"
  end;
  [%expect {| Interrupt_controller.VBlank |}]

let%expect_test "write byte" =
  let t = create () in

  Interrupt_controller.write_byte t ~addr:if_addr ~data:Uint8.(of_int 0x5);
  Interrupt_controller.write_byte t ~addr:ie_addr ~data:Uint8.(of_int 0x5);

  t |> Interrupt_controller.show |> Printf.printf "%s";
  [%expect {| ie:(vblank:1, lcd_stat:0, timer:1, serial_port:0, joypad:0), if:(vblank:1, lcd_stat:0, timer:1, serial_port:0, joypad:0) |}]

let%expect_test "read byte" =
  let t = create () in

  Interrupt_controller.write_byte t ~addr:if_addr ~data:Uint8.(of_int 0x5);
  let byte = Interrupt_controller.read_byte t if_addr in

  byte |> Uint8.show |> Printf.printf "%s";
  [%expect {|$05|}]
