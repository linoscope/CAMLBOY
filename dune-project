(lang dune 3.6)

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
 (synopsis "A Gambeboy emulator written in OCaml")
 (description "A Gambeboy emulator written in OCaml")
 (depends
  (ocaml (>= 4.13.1))
  (brr
   (>= 0.0.4))
  (js_of_ocaml-compiler
   (>= 4.1.0))
  (js_of_ocaml-lwt
   (>= 4.1.0))
  (ppx_deriving
   (>= 4.5))
  (tsdl
   (>= 0.9.8))
  (base
   (and
    (>= v0.14.0)
    :with-test))
  (bigstringaf
   (and
    (>= 0.8.0)
    :with-test))
  (ppx_jane
   (and
    (>= v0.14.0)
    :with-test))))
