# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  nix.extraOptions = "experimental-features = nix-command flakes";
  nixpkgs.config.allowUnfree = true;

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
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
    hostName = "aouh-tour";
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

  security.rtkit.enable = true;

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
      displayManager.lightdm = {
        enable = true;
        greeters.slick = {
          enable = true;
          draw-user-backgrounds = true;
        };
      };
      desktopManager.cinnamon.enable = true;
      videoDrivers = [ "nvidia" ];
      layout = "fr";
      xkbOptions = "eurosign:e";
    };

    transmission = {
      enable = true;
      openPeerPorts = true;
      settings = {
        download-dir = "/mnt/data_0/Torrents";
      };
    };
  };

  qt5 = {
    enable = true;
    style = lib.mkForce "gtk2";
    platformTheme = lib.mkForce "gtk2";
  };

  environment = {
    systemPackages = with pkgs; [
      libsForQt5.qtstyleplugins
    ];
    cinnamon.excludePackages = with pkgs.cinnamon; [
      pix
      warpinator
    ];
  };

  fonts.fonts = with pkgs; [
    nerdfonts
  ];

  users = import ./users.nix pkgs;

  system.stateVersion = "22.11";

}

