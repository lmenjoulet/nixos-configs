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
      profiles = {
        common-basic = # you just need it 
          [
            ./configuration.nix
            ./modules/grub.nix
          ];
        common-desktop = # needs to be combined with a desktop environment to be functional
          [
            ./modules/pipewire.nix
            ./users/configuration.nix
          ];
      };
    in
    {
      nixosConfigurations = {
        babel = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            (import ./modules/transmission.nix { download-dir = "/mnt/data/Torrents"; })
            ./modules/cuda.nix
            ./hardware/babel.nix
            ./modules/kde.nix
            ./modules/steam.nix
            ./modules/wifi-key-tplink.nix
            home-manager.nixosModules.home-manager
            ({ config, pkgs, ... }: {
              networking.hostName = "babel";
              nixpkgs.overlays = [ blender-bin.overlays.default ];
            })
          ]
          ++ profiles.common-basic
          ++ profiles.common-desktop;
        };
        icare = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            (import ./modules/transmission.nix { download-dir = "/mnt/data/Torrents"; })
            ./configuration.nix
            ./hardware/icare.nix
            ./modules/cuda.nix
            ./modules/gnome.nix
            ./modules/grub.nix
            ./modules/nvidia-offload.nix
            ./modules/pipewire.nix
            ./users/configuration.nix
            home-manager.nixosModules.home-manager
            ({ pkgs, ... }: {
              networking.hostName = "icare";
              nixpkgs.overlays = [ blender-bin.overlays.default ];
            })
          ];
        };
      };
    };
}
