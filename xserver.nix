{pkgs, lib, ...}: {
  services = {
    xserver = {
      enable = true;
      desktopManager.xterm.enable = true;
      displayManager.lightdm = {
        enable = true;
      };
      libinput.mouse.accelProfile = "flat";
    };
  };
  programs.dconf.enable = true;
  fonts.fonts = with pkgs; [
    font-awesome_5
  ];
}
