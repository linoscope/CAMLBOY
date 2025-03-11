{ pkgs ? import ./sources.nix { }, nix-filter, doCheck ? false }:

{
  native = {
    camlboy = pkgs.callPackage ./camlboy.nix {
      inherit doCheck nix-filter;
    };
  };

  musl64 =
    let
      pkgsCross = pkgs.pkgsCross.musl64.pkgsStatic;

    in
    {
      camlboy = pkgsCross.callPackage ./camlboy.nix {
        static = true;
        inherit doCheck;
        ocamlPackages = pkgsCross.ocamlPackages;
      };
    };
}
