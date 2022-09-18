{ pkgs, config, ... }: {
  boot = {
    blacklistedKernelModules = [ "rtl8xxxu" ];
    extraModulePackages = [ config.boot.kernelPackages.rtl8192eu ];
    kernelPackages = pkgs.linuxPackages;
  };
}
