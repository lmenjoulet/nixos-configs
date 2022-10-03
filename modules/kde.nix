{ pkgs, ... }: {
  programs.dconf.enable = true;
  services.xserver = {
    enable = true;
    displayManager.sddm.enable = true;
    desktopManager.plasma5 = {
      enable = true;
      excludePackages = with pkgs.libsForQt5; [
        elisa
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
}
