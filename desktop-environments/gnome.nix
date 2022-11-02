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
      gnome-console
    ]) ++ (with pkgs.gnome; [
      epiphany
      totem
      gnome-maps
      gnome-music
      yelp
      gnome-backgrounds
      gnome-system-monitor
    ]);

    systemPackages = with pkgs; [
      libsForQt5.qtstyleplugins
      celluloid
      dialect
      newsflash
      gnome-firmware
      gnome.gnome-tweaks
      ffmpegthumbnailer
      fragments
      lollypop
      blackbox-terminal
    ] ++ (import ./gnome-extensions.nix pkgs);

  };

  networking.firewall = {
    allowedTCPPortRanges = [
      { from = 1714; to = 1764; }
    ];
    allowedUDPPortRanges = [
      { from = 1714; to = 1764; }
    ];
  };
}
