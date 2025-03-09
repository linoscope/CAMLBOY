open Brr

let touchstart = Ev.Type.create (Jstr.v "touchstart")
let touchend = Ev.Type.create (Jstr.v "touchend")

module Touch = struct
  type t = Jv.t
  module Touch' = struct
    type t = Jv.t
    let identifier m = Jv.Int.get m "identifier"
    let client_x m = Jv.Float.get m "clientX"
    let client_y m = Jv.Float.get m "clientY"
    let page_x m = Jv.Float.get m "pageX"
    let page_y m = Jv.Float.get m "pageY"
    let screen_x m = Jv.Float.get m "screenX"
    let screen_y m = Jv.Float.get m "screenY"
  end
  let alt_key m = Jv.Bool.get m "altKey"
  let ctrl_key m = Jv.Bool.get m "ctrlKey"
  let shift_key m = Jv.Bool.get m "shiftKey"
  let meta_key m = Jv.Bool.get m "metaKey"
end
