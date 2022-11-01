{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    gns3-gui
    gns3-server
    tigervnc
    ubridge
    dynamips
    vpcs
    inetutils
  ];
  security.wrappers.ubridge = {
    source = "${pkgs.ubridge}/bin/ubridge";
    capabilities = "cap_net_admin,cap_net_raw=ep";
    owner = "root";
    group = "root";
    permissions = "u+rx,g+x,o+x";
  };
  virtualisation.libvirtd = {
    enable = true;
  };
}
