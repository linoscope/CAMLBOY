(lang dune 2.7)

(generate_opam_files true)

(maintainers "linoshitani@gmail.com")

(package
 (name camlboy)
 (synopsis "A Gambeboy emulator written in OCaml")
 (description "A Gambeboy emulator written in OCaml")
 (depends
  (bigstringaf (>= 0.8.0))
  (ppx_deriving (>= 4.5))
  (ppx_jane (and (>= v0.14.0) :with-test))
  (brr (>= 0.0.2))
  (js_of_ocaml-lwt (>= 3.11.0))
  (tsdl (>= 0.9.8))
   dune))
