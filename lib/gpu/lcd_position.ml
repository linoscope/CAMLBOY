open Uints

type register = {
  addr  : uint16;
  mutable value : int;
}

type t = {
  scy : register;
  scx : register;
  ly  : register;
  lyc : register;
  wy  : register;
  wx  : register;
}

let create ~scy_addr ~scx_addr ~ly_addr ~lyc_addr ~wy_addr ~wx_addr = {
  scy = { addr = scy_addr; value = 0 };
  scx = { addr = scx_addr; value = 0 };
  ly  = { addr =  ly_addr; value = 0 };
  lyc = { addr = lyc_addr; value = 0 };
  wy  = { addr =  wy_addr; value = 0 };
  wx  = { addr =  wx_addr; value = 0 };
}

let get_scy t = t.scy.value
let get_scx t = t.scx.value
let get_ly t = t.ly.value
let incr_ly t = t.ly.value <- t.ly.value + 1
let reset_ly t = t.ly.value <- 0
let get_lyc t = t.lyc.value
let get_wy t = t.wy.value
let get_wx t = t.wx.value


let accepts t addr =
  [t.scy.addr; t.scx.addr; t.ly.addr; t.lyc.addr; t.wy.addr; t.wx.addr]
  |> List.exists (fun x -> Uint16.(addr = x))

let register_of_addr t addr =
  let open Uint16 in
  match addr with
  | _ when addr = t.scy.addr -> t.scy
  | _ when addr = t.scx.addr -> t.scx
  | _ when addr = t.ly.addr  -> t.ly
  | _ when addr = t.lyc.addr -> t.lyc
  | _ when addr = t.wx.addr  -> t.wx
  | _ when addr = t.wy.addr  -> t.wy
  | _ -> raise @@ Invalid_argument (Printf.sprintf "Address out of range: %s" (Uint16.show addr))


let read_byte t addr =
  let r = register_of_addr t addr in
  r.value |> Uint8.of_int

let write_byte t ~addr ~data =
  if Uint16.(addr = t.ly.addr) then
    (* Any write to LY resets it to 0 *)
    t.ly.value <- 0
  else
    let r = register_of_addr t addr in
    r.value <- Uint8.to_int data
