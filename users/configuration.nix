{ pkgs, lib, ... }:
let
  userList = builtins.attrNames (
    lib.filterAttrs (key: val: val == "directory") (builtins.readDir ./.)
  );
in
{
  users.users = builtins.map (
    builtins.listToAttrs (
      builtins.map
        (user: { name = user; value = (import (./. + "/${user}/user.nix")); })
        userlist
    )
  );

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.aouh = import ./home-manager/aouh/config.nix;
    users = builtins.map
      (
        builtins.listToAttrs (
          builtins.map
            (user: { name = user; value = (import (./. + "/${user}/home-manager.nix")); })
            userlist
        )
      );
  };
}
