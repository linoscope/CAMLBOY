type t = {
  divider : Divider.t;
  timer_counter : Timer_counter.t;
}

let create ~div_addr ~tima_addr ~tma_addr ~tac_addr ~ic = {
  divider = Divider.create div_addr;
  timer_counter = Timer_counter.create ~tima_addr ~tma_addr ~tac_addr ~ic;
}

let run t ~mcycles =
  t.divider |> Divider.run ~mcycles;
  t.timer_counter |> Timer_counter.run ~mcycles

let accepts t addr =
  Divider.accepts t.divider addr
  || Timer_counter.accepts t.timer_counter addr

let read_byte t addr =
  match addr with
  | _ when Divider.accepts t.divider addr ->
    Divider.read_byte t.divider addr
  | _ when Timer_counter.accepts t.timer_counter addr ->
    Timer_counter.read_byte t.timer_counter addr
  | _ -> raise @@ Invalid_argument "Address out of bounds"

let write_byte t ~addr ~data =
  match addr with
  | _ when Divider.accepts t.divider addr ->
    Divider.write_byte t.divider ~addr ~data
  | _ when Timer_counter.accepts t.timer_counter addr ->
    Timer_counter.write_byte t.timer_counter ~addr ~data
  | _ -> raise @@ Invalid_argument "Address out of bounds"
