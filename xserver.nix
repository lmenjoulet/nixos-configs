{pkgs, lib, ...}: {
  services = {
    xserver = {
      enable = true;
      desktopManager.xterm.enable = true;
      displayManager.lightdm = {
        enable = true;
        background = ./users/aouh/background.jpg;
        greeters.slick = {
          enable = true;
          theme = {
            package = pkgs.gruvbox-dark-gtk;
            name = "gruvbox-dark";
          };
          font = {
            package = pkgs.terminus_font;
            name = "Terminus";
          };
        };
      };
      libinput.mouse.accelProfile = "flat";
    };
  };
  programs.dconf.enable = true;
  fonts.fonts = with pkgs; [
    font-awesome 
  ];
}
