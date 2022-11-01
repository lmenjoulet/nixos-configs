# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot =
    {
      kernelModules = [ "kvm-intel" ];
      kernelPackages = pkgs.linuxPackages_latest;
      kernelParams = [
        "intel_iommu=on"
      ];
      extraModulePackages = [ ];
      initrd = {
        kernelModules = [ ];
        availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" "rtsx_usb_sdmmc" ];
      };
    };

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/e99254d3-959d-45f9-bedc-c41802b084ab";
      fsType = "ext4";
      options = [
        "noatime"
      ];
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/5CF3-B726";
      fsType = "vfat";
    };

  swapDevices = [ ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}