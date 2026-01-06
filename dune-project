(lang dune 3.17)

(name camlboy)

(generate_opam_files true)

(license MIT)

(authors "Lin Oshitani")

(maintainers "linoshitani@gmail.com")

(source
 (github linoscope/CAMLBOY))

(documentation "https://github.com/linoscope/CAMLBOY")

(package
 (name camlboy)
 (allow_empty)
 (synopsis "A Game Boy emulator written in OCaml")
 (description "A Game Boy emulator written in OCaml")
 (depends
  (ocaml (>= 5.2))
  (wasm_of_ocaml-compiler (>= 6.0.1))
  (brr (>= 0.0.7))
  (js_of_ocaml-compiler (>= 6.0.1))
  (js_of_ocaml-lwt (>= 6.0.1))
  (ppx_deriving (>= 4.5))
  (tsdl (>= 0.9.8))
  (bigstringaf (>= 0.8.0))
  (base (and (>= v0.16.0) :with-test))
  (ppx_jane (and (>= v0.16.0) :with-test))))
