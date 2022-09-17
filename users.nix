{ pkgs, ... }: {
  users.users = {
    aouh = {
      isNormalUser = true;
      description = "Loup Menjoulet";
      homeMode = "770";
      extraGroups = [
        "wheel"
        "adbusers"
        "video"
        "audio"
        "dialout"
        "uucp"
        "networkmanager"
      ];
    };
  };
}


