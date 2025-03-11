supported_ocaml_versions: nix-filter:

final: prev: {
  ocaml-ng = builtins.mapAttrs
    (name: ocamlVersion:
      # If the current ocamlVersion exists in supported versions
      (if (builtins.any (x: x == name) supported_ocaml_versions) then
        ocamlVersion.overrideScope'
          (oself: osuper: {
            camlboy = (prev.callPackage ./camlboy.nix {
              inherit nix-filter;
              ocamlPackages = oself;
              doCheck = true;
            });
          })
      else
        ocamlVersion))
    prev.ocaml-ng;
}
