{
  description = "A note-taking app";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {inherit system;};
        glas = pkgs.rustPlatform.buildRustPackage rec {
          pname = "glas";
          version = "0.2.1";
          src = pkgs.fetchFromGitHub {
            owner = "maurobalbi";
            repo = pname;
            rev = "v${version}";
            hash = "sha256-9RYCWGZ2BHL9SnX6cFXdTkzoWoP5AVkPCexQ1IWjD6s=";
          };

          cargoSha256 = "sha256-8PuZKTVqIM2bcQIID1bodYnCXDHz8UCXo/Y1odglL/U=";

          doCheck = false;
        };
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs;
            [
              gleam
              erlang
              nodejs_21
            ]
            ++ [glas];
        };

        formatter = pkgs.alejandra;
      }
    );
}
