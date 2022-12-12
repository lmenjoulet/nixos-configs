{ pkgs, lib, config, ... }:
let
  # users are created if they have a config folder
  userList = builtins.attrNames (
    lib.filterAttrs (key: val: val == "directory") (builtins.readDir ./.)
  );
in
{
  users = {
    users = builtins.listToAttrs (
      builtins.map
        (user: { name = user; value = (import ./list.nix)."${user}"; })
        userList
    );
  };

  home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      users = builtins.listToAttrs
        (
          builtins.map
            (user: {
              name = user;
              value = lib.mkMerge [
                (import (./. + "/${user}/configuration.nix"))
              ];
            })
            userList
        );
    };
}
