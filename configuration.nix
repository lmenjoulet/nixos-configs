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
    wrappers = {
      plasma-systemmonitor = {
        group = "users";
        owner = "root";
        capabilities = "cap_net_raw+ep";
        source = "${pkgs.libsForQt5.plasma-systemmonitor}/bin/plasma-systemmonitor";
      };
    };
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
      displayManager.sddm.enable = true;
      desktopManager.plasma5.enable = true;
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

  environment = {
    systemPackages = with pkgs; [
      kde-gtk-config
    ];

  };

  fonts.fonts = with pkgs; [
    fira-code
  ];

  users = import ./users.nix pkgs;

  system.stateVersion = "22.11";

}

