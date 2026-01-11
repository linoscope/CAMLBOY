(* Default Game Boy timing parameters *)
let cpu_freq = 4_194_304  (* T-cycles per second *)
let frame_seq_freq = 512  (* Steps per second *)
let tcycles_per_mcycle = 4
let mcycles_per_second = cpu_freq / tcycles_per_mcycle
