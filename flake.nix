{
  inputs = {
    utils.url = "github:numtide/flake-utils";
    naersk.url = "github:nmattia/naersk";
  };

  outputs = { self, nixpkgs, utils, naersk }:
    utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages."${system}";
      naersk-lib = naersk.lib."${system}";
    in rec {
      # `nix build`
      packages.histdb-rs = naersk-lib.buildPackage {
        nativeBuildInputs = [ pkgs.sqlite ];
        pname = "histdb-rs";
        root = ./.;
      };
      defaultPackage = packages.histdb-rs;

      # `nix run`
      apps.histdb-rs = utils.lib.mkApp {
        drv = packages.histdb-rs;
      };
      defaultApp = apps.histdb-rs;

      # `nix develop`
      devShell = pkgs.mkShell {
        # supply the specific rust version
        nativeBuildInputs = [ pkgs.sqlite pkgs.rust ];
      };
    });
}
