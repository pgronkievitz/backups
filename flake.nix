{
  inputs.nixpkgs.url = "nixpkgs/nixos-unstable";
  description = "configs for our backup containers";

  outputs = inputs@{ self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      lib = nixpkgs.lib;
    in {
      packages."${system}" = pkgs;

      nixosConfigurations = {
        restic = lib.nixosSystem {
          inherit system;
          modules = [ ./restic.nix ];
        };
        duplicati = lib.nixosSystem {
          inherit system;
          modules = [ ./duplicati.nix ];
        };
        rsync = lib.nixosSystem {
          inherit system;
          modules = [ ./rsync.nix ];
        };
      };

    };
}
