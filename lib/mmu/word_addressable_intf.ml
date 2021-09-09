open Uints

module type S = sig

  type t

  include Addressable_intf.S with type t := t

  val read_word : t -> uint16 -> uint16

  val write_word : t -> addr:uint16 -> data:uint16 -> unit

end

module Make (M : Addressable_intf.S)  = struct
  open M

  let read_word t addr =
    let lo = Uint8.to_int (read_byte t addr) in
    let hi = Uint8.to_int (read_byte t Uint16.(succ addr)) in
    (hi lsl 8) + lo |> Uint16.of_int

  let write_word t ~addr ~(data : uint16) =
    let data = Uint16.to_int data in
    let hi = data lsr 8 |> Uint8.of_int in
    let lo = data land 0xF |> Uint8.of_int in
    write_byte t ~addr ~data:lo;
    write_byte t ~addr:Uint16.(succ addr) ~data:hi
end
