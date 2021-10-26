type t =
  | ID_00
  | ID_01
  | ID_10
  | ID_11

let of_bits ~hi ~lo =
  match hi, lo with
  | false, false -> ID_00
  | false, true  -> ID_01
  | true, false  -> ID_10
  | true, true   -> ID_11

let to_int = function
  | ID_00 -> 0
  | ID_01 -> 1
  | ID_10 -> 2
  | ID_11 -> 3

let set_bit t = function
  | `Lo ->
    begin match t with
      | ID_00 -> ID_01
      | ID_01 -> ID_01
      | ID_10 -> ID_11
      | ID_11 -> ID_11
    end
  | `Hi ->
    begin match t with
      | ID_00 -> ID_10
      | ID_01 -> ID_11
      | ID_10 -> ID_10
      | ID_11 -> ID_11
    end

let clear_bit t = function
  | `Lo ->
    begin match t with
      | ID_00 -> ID_00
      | ID_01 -> ID_00
      | ID_10 -> ID_10
      | ID_11 -> ID_10
    end
  | `Hi ->
    begin match t with
      | ID_00 -> ID_00
      | ID_01 -> ID_01
      | ID_10 -> ID_00
      | ID_11 -> ID_01
    end

let get_bit t = function
  | `Lo ->
    begin match t with
      | ID_00 | ID_10 -> false
      | ID_01 | ID_11 -> true
    end
  | `Hi ->
    begin match t with
      | ID_00 | ID_01 -> false
      | ID_10 | ID_11 -> true
    end
