{pkgs, lib, ...}: {
  services = {
    autorandr.enable = true;
    xserver = {
      enable = true;
      desktopManager.cinnamon = {
        enable = true;
      };
      displayManager.lightdm = {
        enable = true;
        greeters.slick = {
          enable = true;
        };
      };
      libinput.mouse.accelProfile = "flat";
    };
  };
  environment = {
    systemPackages = with pkgs; [
      gnome.dconf-editor
      qalculate-gtk
      ario
      virt-manager
      thunderbird
      transmission-remote-gtk
    ];
    cinnamon.excludePackages = with pkgs; [
      gnome.gnome-calculator
      hexchat
      onboard
      cinnamon.warpinator
      cinnamon.pix
    ];
  };
  programs.geary.enable = false;
}
