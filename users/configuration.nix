{ pkgs, lib, config, ... }:
let
  userList = builtins.attrNames (
    lib.filterAttrs (key: val: val == "directory") (builtins.readDir ./.)
  );
in
{
  users.users = builtins.listToAttrs (
    builtins.map
      (user: { name = user; value = (import (./. + "/${user}/user.nix")); })
      userList
  );

  home-manager =
    let
      gnomeConfig =
        if config.services.xserver.desktopManager.gnome.enable
        then
          {
            dconf.settings = {
              "org/gnome/shell" = {
                enabled-extensions = builtins.map (x: x.extensionUuid) (import ../modules/gnome-extensions.nix pkgs);
              };
            };
            gtk = {
              enable = true;
              cursorTheme.name = "Adwaita";
              font = {
                package = pkgs.noto-fonts;
                name = "Noto Sans";
              };
              iconTheme = {
                package = pkgs.papirus-icon-theme;
                name = "Papirus-Dark";
              };
              theme = {
                package = pkgs.adw-gtk3;
                name = "adw-gtk3-dark";
              };

            };
          }
        else
          { };
    in
    {
      useGlobalPkgs = true;
      useUserPackages = true;

      users = builtins.listToAttrs
        (
          builtins.map
            (user: {
              name = user;
              value = lib.mkMerge [
                (import (./. + "/${user}/home-manager.nix"))
                gnomeConfig
              ];
            })
            userList
        );
    };
}
