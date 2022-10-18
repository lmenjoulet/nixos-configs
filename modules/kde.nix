{ pkgs, ... }: {
  #programs.dconf.enable = true;
  services.xserver = {
    enable = true;
    displayManager.lightdm.enable = true;
    desktopManager.plasma5 = {
      enable = true;
      excludePackages = with pkgs.libsForQt5; [
        elisa
        plasma-browser-integration
      ];
    };
  };
  environment.systemPackages = with pkgs; [
    libsForQt5.kalendar
    libsForQt5.kmail
    strawberry
    vlc
    libsForQt5.kdepim-addons
    libsForQt5.kdepim-runtime
    libsForQt5.ark
    libsForQt5.kclock
    libsForQt5.kcalc
  ];
  security.wrappers = {
    plasma-systemmonitor = {
      owner = "root";
      group = "root";
      capabilities = "cap_net_raw+ep";
      source = "${pkgs.libsForQt5.plasma-systemmonitor}/bin/plasma-systemmonitor";
    };
  };
}
