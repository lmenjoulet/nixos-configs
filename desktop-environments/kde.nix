{ pkgs, ... }: {
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
      thunderbird
      strawberry
      transmission-qt
      qalculate-qt
      vlc
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
