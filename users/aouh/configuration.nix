{ pkgs, lib, ... }: {
  imports = [
    ./programs/beets.nix
    ./programs/firefox.nix
    ./programs/neovim/configuration.nix 
    ./programs/git.nix
    ./programs/konsole.nix
  ];

  nixpkgs.config.allowUnfree = true;

  home = {
    stateVersion = "22.11";

    packages = with pkgs; [
      blender_3_3
      #ciscoPacketTracer8
      ffmpeg
      flacon
      libsForQt5.kdenlive
      gimp-with-plugins
      keepassxc
      libreoffice
      neofetch
      signal-desktop
      texlive.combined.scheme-full
      zenith-nvidia
    ];
  };
  
  services = {
    syncthing = {
      enable = true;
    };
  };

  programs = {
    yt-dlp = {
      enable = true;
    };
    
    zsh.enable = true;
  };
}


