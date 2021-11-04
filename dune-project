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
   dune))
