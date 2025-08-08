{
  description = "dbSNP BioBrick";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }: 
    flake-utils.lib.eachDefaultSystem (system:
      with import nixpkgs { inherit system; }; {
        devShells.default = mkShell {
          buildInputs = [
            R
            rPackages.fs
            rPackages.purrr
            rPackages.rvest
            rPackages.stringr
            rPackages.pbapply
            wget
          ];
        };
      });
}
