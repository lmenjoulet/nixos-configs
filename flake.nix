{
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    blender-bin = {
      url = github:edolstra/nix-warez?dir=blender;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, home-manager, blender-bin, ... }:
    let
      homeconf = {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          users.aouh = import ./home-manager/aouh/config.nix;
        };
      };
      blender-overlay = ({ config, pkgs, ... }:
        {
          nixpkgs.overlays = [ blender-bin.overlay ];
          environment.systemPackages = [ pkgs.blender ];
        });
    in
    {
      nixosConfigurations = {
        babel = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./configuration.nix
            home-manager.nixosModules.home-manager
            homeconf
            ./modules/machines/babel/hostname.nix
          ];
        };
        icare = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./configuration.nix
            home-manager.nixosModules.home-manager
            homeconf
          ];
        };
      };
    };
}
