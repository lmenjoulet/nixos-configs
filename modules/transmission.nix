{ download-dir, ... }: {
  services.transmission = {
    enable = true;
    group = "users";
    downloadDirPermissions = "750";
    openPeerPorts = true;
    settings = {
      download-dir = download-dir;
    };
  };
}
