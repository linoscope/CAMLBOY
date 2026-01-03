(* Audio Buffer - Ring buffer for accumulating audio samples using bigarrays.

   The APU generates samples at the emulated sample rate (e.g., 44100 Hz).
   These samples are stored in a ring buffer that the audio backend
   (e.g., SDL2) can pull from via callback.

   The buffer uses interleaved stereo int16 bigarray format (L R L R ...)
   for efficient blitting directly to SDL audio buffers.

   Reference: Standard audio ring buffer pattern for real-time audio. *)

type ba = (int, Bigarray.int16_signed_elt, Bigarray.c_layout) Bigarray.Array1.t

type sample = {
  left : int;   (* -32768 to 32767 *)
  right : int;  (* -32768 to 32767 *)
}

type t = {
  buffer : ba;
  capacity : int;           (* In samples (each sample = L + R pair) *)
  mutable write_pos : int;  (* In samples *)
  mutable read_pos : int;   (* In samples *)
  mutable count : int;      (* Number of samples in buffer *)
}

let create capacity = {
  buffer = Bigarray.(Array1.create int16_signed c_layout (capacity * 2));
  capacity;
  write_pos = 0;
  read_pos = 0;
  count = 0;
}

(* Check if buffer is full *)
let is_full t = t.count >= t.capacity

(* Check if buffer is empty *)
let is_empty t = t.count = 0

(* Get number of samples available for reading *)
let available t = t.count

(* Get number of slots available for writing *)
let space_available t = t.capacity - t.count

(* Push a sample to the buffer. Returns true if successful, false if full. *)
let push t ~left ~right =
  if is_full t then
    false
  else begin
    let idx = t.write_pos * 2 in
    t.buffer.{idx} <- left;
    t.buffer.{idx + 1} <- right;
    t.write_pos <- (t.write_pos + 1) mod t.capacity;
    t.count <- t.count + 1;
    true
  end

(* Pop a sample from the buffer. Returns None if empty. *)
let pop t =
  if is_empty t then
    None
  else begin
    let idx = t.read_pos * 2 in
    let sample = { left = t.buffer.{idx}; right = t.buffer.{idx + 1} } in
    t.read_pos <- (t.read_pos + 1) mod t.capacity;
    t.count <- t.count - 1;
    Some sample
  end

(* Pop multiple samples into destination bigarray using blit.
   The destination should be interleaved stereo (L R L R ...).
   Returns number of samples read. *)
let pop_into t ~dst ~count:requested =
  let to_read = min requested t.count in
  if to_read > 0 then begin
    (* Calculate how many samples until wrap-around *)
    let first_chunk = min to_read (t.capacity - t.read_pos) in
    (* Blit first chunk *)
    let src1 = Bigarray.Array1.sub t.buffer (t.read_pos * 2) (first_chunk * 2) in
    let dst1 = Bigarray.Array1.sub dst 0 (first_chunk * 2) in
    Bigarray.Array1.blit src1 dst1;
    (* Blit second chunk if wrap-around *)
    if first_chunk < to_read then begin
      let second_chunk = to_read - first_chunk in
      let src2 = Bigarray.Array1.sub t.buffer 0 (second_chunk * 2) in
      let dst2 = Bigarray.Array1.sub dst (first_chunk * 2) (second_chunk * 2) in
      Bigarray.Array1.blit src2 dst2
    end;
    t.read_pos <- (t.read_pos + to_read) mod t.capacity;
    t.count <- t.count - to_read
  end;
  to_read

(* Clear the buffer *)
let clear t =
  t.write_pos <- 0;
  t.read_pos <- 0;
  t.count <- 0

(* Get buffer capacity *)
let capacity t = t.capacity
