{ pkgs, nix-filter, stdenv, lib, ocamlPackages, static ? false, doCheck }:

with ocamlPackages;
buildDunePackage {
  pname = "camlboy";
  version = "0.1.0";

  src = nix-filter.lib.filter {
    root = ../.;
    # TODO: package the brr and include the browser front end
    include = [
      "lib"
      "bin/sdl2"
      "dune"
      "dune-project"
      "camlboy.opam"
      "resources"
    ];
  };

  # Static builds support, note that you need a static profile in your dune file
  buildPhase = ''
    echo "running ${if static then "static" else "release"} build"
    dune build --profile=${if static then "static" else "release"}
  '';

  checkInputs = [ ];

  propagatedBuildInputs = [
    ppx_deriving
    tsdl
    base
    bigstringaf
    ppx_jane
    odoc
  ];

  inherit doCheck;

  meta = {
    description = "A Game Boy emulator written in OCaml that runs in your browser";
  };
}
