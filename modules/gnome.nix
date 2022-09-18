{ pkgs, lib, ... }: {
  services = {
    xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      displayManager.gdm.wayland = lib.mkForce true;
      desktopManager.gnome.enable = true;
    };
  };
  qt5 = {
    enable = true;
    style = lib.mkForce "gtk2";
    platformTheme = lib.mkForce "gtk2";
  };

  environment = {
    gnome.excludePackages = (with pkgs; [
      gnome-photos
      gnome-tour
    ]) ++ (with pkgs.gnome; [
      gnome-music
      epiphany
      totem
      gnome-maps
      yelp
      gnome-backgrounds
    ]);

    systemPackages = with pkgs; [
      libsForQt5.qtstyleplugins
      amberol
      celluloid
      gnome.gnome-tweaks
    ];

  };

}
