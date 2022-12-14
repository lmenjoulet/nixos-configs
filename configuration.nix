# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, nixpkgs, ... }:
{
  nix = {
    extraOptions = "experimental-features = nix-command flakes";
    settings.auto-optimise-store = true;
  };

  nixpkgs.config.allowUnfree = true;

  networking = {
    networkmanager.enable = true;
  };
  time.timeZone = "Europe/Paris";
  i18n.defaultLocale = "fr_FR.UTF-8";
  console.keyMap = "fr";
  zramSwap.enable = true;
  systemd.services = {
    NetworkManager-wait-online.enable = false;
  };
  services = {
    printing.enable = true;
    xserver = {
      layout = "fr";
      xkbOptions = "eurosign:e";
    };
  };
  
  system.stateVersion = "22.11";

}

