{ pkgs, config, ... }: {
  boot = {
    blacklistedKernelModules = [ "r8188eu" ];
    #kernelModules = [ "r8188eu" ];
    extraModulePackages = [ config.boot.kernelPackages.rtl8188eus-aircrack ];
    kernelPackages = pkgs.linuxPackages;
  };
}
