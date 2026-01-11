include Camlboy_lib

let%expect_test "initial state is empty" =
  let buf = Audio_buffer.create 10 in
  Printf.printf "empty: %b, available: %d, space: %d\n"
    (Audio_buffer.is_empty buf)
    (Audio_buffer.available buf)
    (Audio_buffer.space_available buf);
  [%expect {| empty: true, available: 0, space: 10 |}]

let%expect_test "push and pop single sample" =
  let buf = Audio_buffer.create 10 in
  let pushed = Audio_buffer.push buf ~left:100 ~right:(-100) in
  Printf.printf "pushed: %b, available: %d\n" pushed (Audio_buffer.available buf);
  (match Audio_buffer.pop buf with
   | Some s -> Printf.printf "left: %d, right: %d\n" s.left s.right
   | None -> print_endline "empty");
  Printf.printf "available after pop: %d\n" (Audio_buffer.available buf);
  [%expect {|
    pushed: true, available: 1
    left: 100, right: -100
    available after pop: 0 |}]

let%expect_test "buffer full behavior" =
  let buf = Audio_buffer.create 3 in
  let r1 = Audio_buffer.push buf ~left:1 ~right:1 in
  let r2 = Audio_buffer.push buf ~left:2 ~right:2 in
  let r3 = Audio_buffer.push buf ~left:3 ~right:3 in
  let r4 = Audio_buffer.push buf ~left:4 ~right:4 in  (* Should fail *)
  Printf.printf "pushes: %b %b %b %b\n" r1 r2 r3 r4;
  Printf.printf "full: %b, available: %d\n"
    (Audio_buffer.is_full buf) (Audio_buffer.available buf);
  [%expect {|
    pushes: true true true false
    full: true, available: 3 |}]

let%expect_test "pop_into multiple samples" =
  let buf = Audio_buffer.create 10 in
  for i = 1 to 5 do
    let _ = Audio_buffer.push buf ~left:(i * 10) ~right:(i * (-10)) in ()
  done;
  (* Use bigarray destination (interleaved: L R L R ...) *)
  let dst = Bigarray.(Array1.create int16_signed c_layout (3 * 2)) in
  let count = Audio_buffer.pop_into buf ~dst ~count:3 in
  Printf.printf "read: %d, remaining: %d\n" count (Audio_buffer.available buf);
  Printf.printf "left: [%d, %d, %d]\n" dst.{0} dst.{2} dst.{4};
  Printf.printf "right: [%d, %d, %d]\n" dst.{1} dst.{3} dst.{5};
  [%expect {|
    read: 3, remaining: 2
    left: [10, 20, 30]
    right: [-10, -20, -30] |}]

let%expect_test "pop_into requests more than available" =
  let buf = Audio_buffer.create 10 in
  let _ = Audio_buffer.push buf ~left:100 ~right:200 in
  let _ = Audio_buffer.push buf ~left:300 ~right:400 in
  let dst = Bigarray.(Array1.create int16_signed c_layout (5 * 2)) in
  let count = Audio_buffer.pop_into buf ~dst ~count:5 in
  Printf.printf "requested: 5, read: %d\n" count;
  Printf.printf "left: [%d, %d]\n" dst.{0} dst.{2};
  [%expect {|
    requested: 5, read: 2
    left: [100, 300] |}]

let%expect_test "clear empties buffer" =
  let buf = Audio_buffer.create 10 in
  for _ = 1 to 5 do
    let _ = Audio_buffer.push buf ~left:1 ~right:1 in ()
  done;
  Printf.printf "before clear: %d\n" (Audio_buffer.available buf);
  Audio_buffer.clear buf;
  Printf.printf "after clear: %d, empty: %b\n"
    (Audio_buffer.available buf) (Audio_buffer.is_empty buf);
  [%expect {|
    before clear: 5
    after clear: 0, empty: true |}]

let%expect_test "ring buffer wraps around correctly" =
  let buf = Audio_buffer.create 3 in
  (* Fill buffer *)
  let _ = Audio_buffer.push buf ~left:1 ~right:1 in
  let _ = Audio_buffer.push buf ~left:2 ~right:2 in
  let _ = Audio_buffer.push buf ~left:3 ~right:3 in
  (* Pop two *)
  let _ = Audio_buffer.pop buf in
  let _ = Audio_buffer.pop buf in
  (* Push two more (wraps around) *)
  let _ = Audio_buffer.push buf ~left:4 ~right:4 in
  let _ = Audio_buffer.push buf ~left:5 ~right:5 in
  Printf.printf "available: %d\n" (Audio_buffer.available buf);
  (* Pop all and verify order *)
  (match Audio_buffer.pop buf with Some s -> Printf.printf "%d " s.left | None -> ());
  (match Audio_buffer.pop buf with Some s -> Printf.printf "%d " s.left | None -> ());
  (match Audio_buffer.pop buf with Some s -> Printf.printf "%d\n" s.left | None -> ());
  [%expect {|
    available: 3
    3 4 5 |}]

let%expect_test "pop_into with wrap-around uses blit correctly" =
  let buf = Audio_buffer.create 4 in
  (* Push 3, pop 2 to move read position *)
  let _ = Audio_buffer.push buf ~left:1 ~right:10 in
  let _ = Audio_buffer.push buf ~left:2 ~right:20 in
  let _ = Audio_buffer.push buf ~left:3 ~right:30 in
  let _ = Audio_buffer.pop buf in
  let _ = Audio_buffer.pop buf in
  (* Now read_pos=2, push 3 more (wraps around) *)
  let _ = Audio_buffer.push buf ~left:4 ~right:40 in
  let _ = Audio_buffer.push buf ~left:5 ~right:50 in
  let _ = Audio_buffer.push buf ~left:6 ~right:60 in
  (* Buffer now has: [5,6,3,4] with read_pos=2, count=4 *)
  (* Pop all 4 with pop_into - should handle wrap correctly *)
  let dst = Bigarray.(Array1.create int16_signed c_layout (4 * 2)) in
  let count = Audio_buffer.pop_into buf ~dst ~count:4 in
  Printf.printf "read: %d\n" count;
  Printf.printf "samples: (%d,%d) (%d,%d) (%d,%d) (%d,%d)\n"
    dst.{0} dst.{1} dst.{2} dst.{3} dst.{4} dst.{5} dst.{6} dst.{7};
  [%expect {|
    read: 4
    samples: (3,30) (4,40) (5,50) (6,60) |}]
