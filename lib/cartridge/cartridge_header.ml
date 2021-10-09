type cartridge_type = [`ROM_ONLY | `MBC1]

type t = {
  cartridge_type : cartridge_type;
}

let create ~rom_bytes =
  let cartridge_type =
    match Bytes.get_int8 rom_bytes 0x147 with
    | 0x00 -> `ROM_ONLY
    | 0x01 -> `MBC1
    | _ -> assert false
  in
  { cartridge_type; }

let get_cartridge_type t = t.cartridge_type
