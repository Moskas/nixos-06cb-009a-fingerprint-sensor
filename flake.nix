{
  description = "Provides packages, modules and functions for the 06cb:009a fingerprint sensor.";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.11";
  };

  outputs =
    {
      self,
      nixpkgs,
    }:
    let
      pkgs = import nixpkgs { system = "x86_64-linux"; };
      localPackages = import ./pkgs/default.nix { pkgs = pkgs; };
      localLib = import ./lib {
        pkgs = pkgs;
        localPackages = localPackages;
      };

      wrapModule = import ./lib/wrapModule.nix;
    in
    {
      nixosModules.python-validity = wrapModule { inherit localPackages; } ./modules/python-validity;

      nixosModules.open-fprintd = ./modules/open-fprintd;

      nixosModules.fingerprint06cb009a = wrapModule {
        inherit localPackages;
        libfprint-2-tod1-vfs0090-bingch = localLib.libfprint-2-tod1-vfs0090-bingch;
      } ./modules/06cb-009a-fingerprint-sensor;

      nixosModules.default = self.nixosModules.fingerprint06cb009a;
      packages."x86_64-linux" = localPackages;
    };
}
