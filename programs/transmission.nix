{ ... }: {
  services.transmission = {
    enable = true;
    group = "users";
    openPeerPorts = true;
  };
}
