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
        common-basic =
          [
            ./configuration.nix
            ./modules/grub.nix
            ./modules/security.nix
            ./modules/pipewire.nix
            ./users/configuration.nix
            home-manager.nixosModules.home-manager
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
            ./modules/gns3.nix
            ({ config, pkgs, ... }: {
              networking.hostName = "babel";
              nixpkgs.overlays = [ blender-bin.overlays.default ];
            })
          ]
          ++ profiles.common-basic;
        };
        icare = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./modules/transmission.nix
            ./hardware/icare.nix
            ./modules/cuda.nix
            ./modules/kde.nix
            ./modules/nvidia-offload.nix
            ({ pkgs, ... }: {
              networking.hostName = "icare";
              nixpkgs.overlays = [ blender-bin.overlays.default ];
            })
          ] ++ profiles.common-basic;
        };
      };
    };
}
