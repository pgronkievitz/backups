{ config, lib, pkgs, ... }: {
  boot.isContainer = true;
  networking.firewall.allowedTCPPorts = [ 8200 ];
  services.duplicati = {
    enable = true;
    user = "root";
    interface = "any";
  };
}
