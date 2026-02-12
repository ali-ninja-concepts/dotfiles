{ pkgs, ... }:

{
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  networking.networkmanager.plugins = with pkgs; [
    networkmanager-openvpn
  ];

  networking.firewall = {
    enable = true;
    trustedInterfaces = [ "docker0" ];
    extraCommands = ''
      iptables -I INPUT -i br-+ -j ACCEPT
    '';
  };

  time.timeZone = "Asia/Calcutta";
  i18n.defaultLocale = "en_US.UTF-8";
}
