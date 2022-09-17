{
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, home-manager, ... }:
    let
      homeconf = {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          users.aouh = import ./home-manager/aouh/config.nix;
        };
      };
    in
    {
      nixosConfigurations = {
        babel = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./configuration.nix
            ./modules/wifi-key-tplink.nix
            ./modules/pipewire.nix
            ./modules/grub.nix
            home-manager.nixosModules.home-manager
            homeconf
            ({ pkgs, ... }: { networking.hostName = "babel"; })
          ];
        };
        icare = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./configuration.nix
            home-manager.nixosModules.home-manager
            homeconf
            ({ pkgs, ... }: { networking.hostName = "icare"; })
          ];
        };
      };
    };
}
