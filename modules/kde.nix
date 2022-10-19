{ pkgs, ... }: {
  #programs.dconf.enable = true;
  services.xserver = {
    enable = true;
    displayManager.sddm.enable = true;
    desktopManager.plasma5 = {
      enable = true;
      excludePackages = with pkgs.libsForQt5; [
        elisa
        plasma-browser-integration
      ];
    };
  };
  environment = {
    sessionVariables = {
      GTK_USE_PORTAL = "1";
    };

    systemPackages = with pkgs; [
      libsForQt5.kalendar
      thunderbird
      strawberry
      transmission-qt
      vlc
      libsForQt5.kdepim-addons
      libsForQt5.kdepim-runtime
      libsForQt5.ark
      libsForQt5.kclock
      libsForQt5.kcalc
      kde-gruvbox
    ];
  };
  programs.kdeconnect.enable = true;
  security.wrappers = {
    plasma-systemmonitor = {
      owner = "root";
      group = "root";
      capabilities = "cap_net_raw+ep";
      source = "${pkgs.libsForQt5.plasma-systemmonitor}/bin/plasma-systemmonitor";
    };
  };
}
