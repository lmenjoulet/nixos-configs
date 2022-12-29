{
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-22.11;
    home-manager = {
      url = github:nix-community/home-manager/release-22.11;
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
            (import ./programs/transmission.nix { download-dir = "/mnt/data/Torrents"; })
            ./machines/babel.nix
            ./desktop-environments/kde.nix
            ./programs/steam.nix
            ./programs/gns3.nix
            ./programs/zsh.nix
            ./programs/gpg.nix
            ./hardware/android.nix
            ./configuration.nix
            ./hardware/fwupd.nix
            ./hardware/pipewire.nix
            ./users/configuration.nix
            home-manager.nixosModules.home-manager

            ({ config, pkgs, ... }: {
              networking.hostName = "babel";
              nix.registry.nixpkgs.flake = nixpkgs;
              nixpkgs.overlays = [ blender-bin.overlays.default ];
            })
          ];
        };
        icare = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./programs/transmission.nix
            ./programs/gpg.nix
            ./machines/icare.nix
            ./desktop-environments/kde.nix
            ./hardware/nvidia-offload.nix
            ./programs/zsh.nix
            ./hardware/android.nix
            ./configuration.nix
            ./hardware/fwupd.nix
            ./hardware/pipewire.nix
            ./users/configuration.nix
            home-manager.nixosModules.home-manager
            ({ pkgs, ... }: {
              networking.hostName = "icare";
              nix.registry.nixpkgs.flake = nixpkgs;
              nixpkgs.overlays = [ blender-bin.overlays.default ];
            })
          ];
        };
      };
    };
}
