(* Minimal WAV file writer for 16-bit stereo PCM audio *)

type t = {
  out : out_channel;
  mutable samples_written : int;
}

let output_u16_le out v =
  output_byte out (v land 0xFF);
  output_byte out ((v lsr 8) land 0xFF)

let output_u32_le out v =
  output_byte out (v land 0xFF);
  output_byte out ((v lsr 8) land 0xFF);
  output_byte out ((v lsr 16) land 0xFF);
  output_byte out ((v lsr 24) land 0xFF)

let create ~filename ~sample_rate ~channels =
  let out = open_out_bin filename in
  let byte_rate = sample_rate * channels * 2 in
  let block_align = channels * 2 in
  output_string out "RIFF";
  output_u32_le out 0;  (* file size - 8, updated on close *)
  output_string out "WAVEfmt ";
  output_u32_le out 16;  (* fmt chunk size *)
  output_u16_le out 1;   (* format: PCM *)
  output_u16_le out channels;
  output_u32_le out sample_rate;
  output_u32_le out byte_rate;
  output_u16_le out block_align;
  output_u16_le out 16;  (* bits per sample *)
  output_string out "data";
  output_u32_le out 0;   (* data size, updated on close *)
  { out; samples_written = 0 }

let write_samples t buffer count =
  for i = 0 to count * 2 - 1 do
    let sample = buffer.{i} in
    output_byte t.out (sample land 0xFF);
    output_byte t.out ((sample lsr 8) land 0xFF)
  done;
  t.samples_written <- t.samples_written + count

let close t =
  let data_size = t.samples_written * 4 in
  let file_size = 36 + data_size in
  seek_out t.out 4;
  output_u32_le t.out file_size;
  seek_out t.out 40;
  output_u32_le t.out data_size;
  close_out t.out
