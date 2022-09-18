{ pkgs, lib, ... }:
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

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    users = builtins.listToAttrs (
      builtins.map
        (user: {
          name = user;
          value = import (./. + "/${user}/home-manager.nix");
        })
        userList
    );
  };
}