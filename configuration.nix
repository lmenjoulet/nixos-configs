# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  nix = {
    extraOptions = "experimental-features = nix-command flakes";
    settings = {
      substituters = [
        "https://cuda-maintainers.cachix.org"
      ];
      trusted-public-keys = [
        "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
      ];
    };
  };
  nixpkgs.config.allowUnfree = true;
  boot = {
    blacklistedKernelModules = [ "rtl8xxxu" ];
    extraModulePackages = [ config.boot.kernelPackages.rtl8192eu ];
    kernelPackages = pkgs.linuxPackages;
    loader = {
      grub = {
        enable = true;
        efiSupport = true;
        devices = [ "nodev" ];
        gfxmodeEfi = "1920x1080";
      };
      efi = {
        canTouchEfiVariables = true;
      };
    };
  };

  networking = {
    networkmanager.enable = true;
    firewall = {
      allowedTCPPorts = [
        22000
      ];
      allowedUDPPorts = [
        22000
        21027
      ];
    };
  };

  time.timeZone = "Europe/Paris";

  i18n.defaultLocale = "fr_FR.UTF-8";

  console.keyMap = "fr";

  zramSwap.enable = true;

  hardware = {
    opengl = {
      enable = true;
      extraPackages = with pkgs; [
        vaapiVdpau
        libvdpau-va-gl
      ];
      setLdLibraryPath = true;
    };
    pulseaudio.enable = false;
  };

  security = {
    rtkit.enable = true;
  };

  systemd.services = {
    NetworkManager-wait-online.enable = false;
  };

  services = {
    printing.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };

    xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
      videoDrivers = [ "nvidia" ];
      layout = "fr";
      xkbOptions = "eurosign:e";
    };

    transmission = {
      enable = true;
      openPeerPorts = true;
      settings = {
        download-dir = "/mnt/data/Torrents";
      };
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
    ];

  };

  fonts.fonts = with pkgs; [
    fira-code
  ];

  users = import ./users.nix pkgs;

  system.stateVersion = "22.11";

}

