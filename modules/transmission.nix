{ download-dir, ... }: {
  services.transmission = {
    enable = true;
    openPeerPorts = true;
    settings = {
      download-dir = download-dir;
    };
  };
}
