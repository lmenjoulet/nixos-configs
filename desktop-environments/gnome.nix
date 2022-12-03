{ pkgs, lib, ... }: {
  services = {
    xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      displayManager.gdm.wayland = true;
      desktopManager.gnome.enable = true;
      windowManager.fluxbox.enable = true;
    };
  };
  qt5 = {
    enable = true;
    style = lib.mkForce "adwaita-dark";
    platformTheme = lib.mkForce "gnome";
  };

  environment = {
    gnome.excludePackages = (with pkgs; [
      gnome-photos
      gnome-tour
      gnome-console
    ]) ++ (with pkgs.gnome; [
      epiphany
      totem
      gnome-calculator
      gnome-maps
      gnome-music
      yelp
      gnome-backgrounds
      gnome-system-monitor
    ]);

    systemPackages = with pkgs; [
      adwaita-qt
      qgnomeplatform
      celluloid
      dialect
      newsflash
      qalculate-gtk
      gnome-firmware
      gnome.gnome-boxes
      gnome.gnome-tweaks
      gnome.gnome-terminal
      ffmpegthumbnailer
      transmission-remote-gtk
      lollypop
      sonata
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
