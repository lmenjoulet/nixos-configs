{ pkgs, ... }: {
  boot.loader = {
    grub = {
      enable = true;
      efiSupport = true;
      devices = [ "nodev" ];
      gfxmodeEfi = "1920x1080";
    };
    efi = {
      canTouchEfiVariables = true;
    };
  };
}
