(lang dune 2.9)

(generate_opam_files true)

(license MIT)

(authors "Lin Oshitani")

(maintainers "linoshitani@gmail.com")

(source
 (github linoscope/CAMLBOY))

(documentation "https://github.com/linoscope/CAMLBOY")

(package
 (name camlboy)
 (synopsis "A Gambeboy emulator written in OCaml")
 (description "A Gambeboy emulator written in OCaml")
 (depends
  (brr
   (>= 0.0.2))
  (js_of_ocaml-compiler
   (>= 3.11.0))
  (js_of_ocaml-lwt
   (>= 3.11.0))
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
