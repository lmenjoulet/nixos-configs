{ pkgs, ... }: {
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
  };
  hardware.pulseaudio.enable = false;
}

