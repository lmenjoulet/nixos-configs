{ pkgs, ... }: {
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware = {
    nvidia.modesetting.enable = true;
    opengl = {
      enable = true;
      extraPackages = with pkgs; [
        vaapiVdpau
        libvdpau-va-gl
        libva-utils
      ];
    };
  };
}
