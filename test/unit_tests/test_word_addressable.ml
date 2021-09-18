open Camlboy_lib
open Uints

module M = struct
  include Mock_mmu
  include Word_addressable.Make (Mock_mmu)
end

let%expect_test "write then read" =
  let t = M.create ~size:10 in

  M.write_word t ~addr:Uint16.zero ~data:Uint16.(of_int 0xAABB);

  M.read_word t Uint16.zero
  |> Uint16.show
  |> print_endline;

  [%expect {| $AABB |}]
