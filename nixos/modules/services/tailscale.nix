{ pkgs, ... }:

{
  services.tailscale.enable = true;

  environment.systemPackages = [ pkgs.tailscale ];

  # Allow Tailscale's UDP port through the firewall
  networking.firewall = {
    allowedUDPPorts = [ 41641 ];
    trustedInterfaces = [ "tailscale0" ];
  };
}
