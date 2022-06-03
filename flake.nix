{
  description = "Yatima Language";

  inputs = {
    lean = {
      url = github:leanprover/lean4;
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs.url = github:nixos/nixpkgs/nixos-21.11;

    flake-utils = {
      url = github:numtide/flake-utils;
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { self, lean, flake-utils, nixpkgs }:
    let
      supportedSystems = [
        # "aarch64-linux"
        # "aarch64-darwin"
        # "i686-linux"
        # "x86_64-darwin"
        "x86_64-linux"
      ];
    in
    flake-utils.lib.eachSystem supportedSystems (system:
      let
        leanPkgs = lean.packages.${system};
        pkgs = nixpkgs.legacyPackages.${system};
        project = leanPkgs.buildLeanPackage {
          debug = false;
          name = "Megparsec.lean";
          src = ./src;
        };
      in
      {
        inherit project;
        packages = {
          # inherit (leanPkgs) lean;
          # TODO
        };

        devShell = pkgs.mkShell {
          buildInputs = [
            pkgs.ghc
            pkgs.cabal-install
            pkgs.haskell-language-server
            pkgs.haskellPackages.implicit-hie
            leanPkgs.lean
          ];
        };

        defaultPackage = pkgs.hello;
      });
}
