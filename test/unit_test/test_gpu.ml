open Camlboy_lib
open Uints

let lcd_stat_addr = Uint16.of_int 0xFF41
let lcd_control_addr = Uint16.of_int 0xFF40
let lyc_addr = Uint16.of_int 0xFF45
let ic = Interrupt_controller.create
    ~ie_addr:(Uint16.of_int 0xFFFF)
    ~if_addr:(Uint16.of_int 0xFF0F)

(* This is more of an integration test since we don't mock the dependencies such as Tile_data. *)
let create ()=
  let open Uint16 in
  let tile_data = Tile_data.create
      ~start_addr:(of_int 0x8000)
      ~end_addr:(of_int 0x97FF)
  in
  let tile_map = Tile_map.create
      ~area0_start_addr:(Uint16.of_int 0x9800)
      ~area0_end_addr:(Uint16.of_int 0x9BFF)
      ~area1_start_addr:(Uint16.of_int 0x9C00)
      ~area1_end_addr:(Uint16.of_int 0x9800)
  in
  let oam_table = Oam_table.create
      ~start_addr:(of_int 0xFE00)
      ~end_addr:(of_int 0xFE9F)
  in
  Interrupt_controller.write_byte ic ~addr:(Uint16.of_int 0xFFFF) ~data:(Uint8.of_int 0xFF);
  Gpu.create
    ~tile_data
    ~tile_map
    ~oam:oam_table
    ~bgp:(Pallete.create ~addr:(of_int 0xFF47))
    ~obp0:(Pallete.create ~addr:(of_int 0xFF48))
    ~obp1:(Pallete.create ~addr:(of_int 0xFF49))
    ~lcd_control:(Lcd_control.create ~addr:lcd_control_addr)
    ~lcd_stat:(Lcd_stat.create ~addr:lcd_stat_addr)
    ~lcd_position:(
      Lcd_position.create
        ~scy_addr:(of_int 0xFF42)
        ~scx_addr:(of_int 0xFF43)
        ~ly_addr:(of_int 0xFF44)
        ~lyc_addr:lyc_addr
        ~wy_addr:(of_int 0xFF4A)
        ~wx_addr:(of_int 0xFF4B))
    ~ic

let run_and_print_transitions t mcycles =
  (* Print gpu state right before and right after mode transition  *)
  Gpu.For_tests.show t |> print_endline;
  for _ = 0 to mcycles - 1 do
    let before_run_state = Gpu.For_tests.show t in
    begin match Gpu.For_tests.run t ~mcycles:1 with
      | `Mode_not_changed -> ()
      | `Mode_changed ->
        let after_run_state = Gpu.For_tests.show t in
        before_run_state |> print_endline;
        after_run_state  |> print_endline
    end;
    Interrupt_controller.clear_all ic;
  done

let enable_all_interrupt_source t =
  let lcd_byte = Gpu.read_byte t lcd_stat_addr in
  Gpu.write_byte t ~addr:lcd_stat_addr ~data:Uint8.(lcd_byte lor of_int 0b01111000)

let enable_lyc_eq_ly_interrupt_source t =
  let lcd_byte = Gpu.read_byte t lcd_stat_addr in
  Gpu.write_byte t ~addr:lcd_stat_addr ~data:Uint8.(lcd_byte lor of_int 0b01000000)

let%expect_test "test mode transition in single line" =
  let t = create () in

  run_and_print_transitions t 115;

  [%expect {|
    mode=2, mcycles=   0, ly=  0, lcd_stat=$86, interrupt=-)
    mode=2, mcycles=  19, ly=  0, lcd_stat=$86, interrupt=-)
    mode=3, mcycles=   0, ly=  0, lcd_stat=$87, interrupt=-)
    mode=3, mcycles=  42, ly=  0, lcd_stat=$87, interrupt=-)
    mode=0, mcycles=   0, ly=  0, lcd_stat=$84, interrupt=-)
    mode=0, mcycles=  50, ly=  0, lcd_stat=$84, interrupt=-)
    mode=2, mcycles=   0, ly=  1, lcd_stat=$82, interrupt=-) |}]

let%expect_test "test mode transition in single line with interrupts enabled" =
  let t = create () in

  enable_all_interrupt_source t;
  run_and_print_transitions t 115;

  [%expect {|
    mode=2, mcycles=   0, ly=  0, lcd_stat=$FE, interrupt=-)
    mode=2, mcycles=  19, ly=  0, lcd_stat=$FE, interrupt=-)
    mode=3, mcycles=   0, ly=  0, lcd_stat=$FF, interrupt=-)
    mode=3, mcycles=  42, ly=  0, lcd_stat=$FF, interrupt=-)
    mode=0, mcycles=   0, ly=  0, lcd_stat=$FC, interrupt=LCD_stat)
    mode=0, mcycles=  50, ly=  0, lcd_stat=$FC, interrupt=-)
    mode=2, mcycles=   0, ly=  1, lcd_stat=$FA, interrupt=LCD_stat) |}]

let%expect_test "test lcd_stat properly set when lyc=ly" =
  let t = create () in

  enable_lyc_eq_ly_interrupt_source t;
  Gpu.write_byte t ~addr:lyc_addr ~data:(Uint8.of_int 0x01);

  run_and_print_transitions t 250;

  [%expect {|
    mode=2, mcycles=   0, ly=  0, lcd_stat=$C6, interrupt=-)
    mode=2, mcycles=  19, ly=  0, lcd_stat=$C6, interrupt=-)
    mode=3, mcycles=   0, ly=  0, lcd_stat=$C7, interrupt=-)
    mode=3, mcycles=  42, ly=  0, lcd_stat=$C7, interrupt=-)
    mode=0, mcycles=   0, ly=  0, lcd_stat=$C4, interrupt=-)
    mode=0, mcycles=  50, ly=  0, lcd_stat=$C4, interrupt=-)
    mode=2, mcycles=   0, ly=  1, lcd_stat=$C6, interrupt=LCD_stat)
    mode=2, mcycles=  19, ly=  1, lcd_stat=$C6, interrupt=-)
    mode=3, mcycles=   0, ly=  1, lcd_stat=$C7, interrupt=-)
    mode=3, mcycles=  42, ly=  1, lcd_stat=$C7, interrupt=-)
    mode=0, mcycles=   0, ly=  1, lcd_stat=$C4, interrupt=-)
    mode=0, mcycles=  50, ly=  1, lcd_stat=$C4, interrupt=-)
    mode=2, mcycles=   0, ly=  2, lcd_stat=$C2, interrupt=-)
    mode=2, mcycles=  19, ly=  2, lcd_stat=$C2, interrupt=-)
    mode=3, mcycles=   0, ly=  2, lcd_stat=$C3, interrupt=-) |}]

let%expect_test "test disabling lcd resets ly and changes mode to HBlank" =
  let t = create () in

  for _ = 0 to 115 do
    ignore @@ Gpu.run t ~mcycles:1;
  done;
  run_and_print_transitions t 1;
  Gpu.write_byte t ~addr:lcd_control_addr ~data:(Uint8.of_int 0x00); (* disable lcd *)
  run_and_print_transitions t 1;

  [%expect {|
    mode=2, mcycles=   2, ly=  1, lcd_stat=$82, interrupt=-)
    mode=0, mcycles=   0, ly=  0, lcd_stat=$80, interrupt=-) |}]
