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
    {
      nixosConfigurations = {
        babel = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            (import ./modules/transmission.nix { download-dir = "/mnt/data/Torrents"; })
            ./configuration.nix
            ./hardware/babel.nix
            ./modules/cuda.nix
            ./modules/gnome.nix
            ./modules/grub.nix
            ./modules/nvidia.nix
            ./modules/pipewire.nix
            ./modules/wifi-key-tplink.nix
            ./users/configuration.nix
            home-manager.nixosModules.home-manager
            ({ config, pkgs, ... }: {
              networking.hostName = "babel";
              nixpkgs.overlays = [ blender-bin.overlays.default ];
            })
          ];
        };
        icare = nixpkgs.lib.nixosSystem
          {
            system = "x86_64-linux";
            modules = [
              ./configuration.nix
              home-manager.nixosModules.home-manager
              ({ pkgs, ... }: { networking.hostName = "icare"; })
            ];
          };
      };
    };
}
