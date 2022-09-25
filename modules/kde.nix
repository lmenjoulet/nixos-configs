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
    kalendar
    kmail
    strawberry
    vlc
  ];
}
