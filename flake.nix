{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    ocaml-overlay.url = "github:anmonteiro/nix-overlays";
    ocaml-overlay.inputs.flake-utils.follows = "flake-utils";

    nix-filter.url = "github:numtide/nix-filter";
  };

  outputs = { self, nixpkgs, flake-utils, ocaml-overlay, nix-filter }:
    let
      supported_ocaml_versions = [ "ocamlPackages_4_12" "ocamlPackages_4_13" "ocamlPackages_5_00" ];
      out = system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ ocaml-overlay.overlay ];
          };
          inherit (pkgs) lib;
          myPkgs = pkgs.recurseIntoAttrs (import ./nix {
            inherit pkgs nix-filter;
            doCheck = true;
          }).native;
          myDrvs = lib.filterAttrs (_: value: lib.isDerivation value) myPkgs;
        in
        {
          devShell = (pkgs.mkShell {
            inputsFrom = lib.attrValues myDrvs;
            buildInputs = with pkgs;
              with ocamlPackages; [
                ocaml-lsp
                ocamlformat
                odoc
                ocaml
                dune_3
                nixfmt
                utop
              ];
          });

          defaultPackage = myPkgs.camlboy;
        };
    in
    with flake-utils.lib; eachSystem defaultSystems out // {
      overlays = { default = import ./nix/overlay.nix supported_ocaml_versions nix-filter; };
    };
}
