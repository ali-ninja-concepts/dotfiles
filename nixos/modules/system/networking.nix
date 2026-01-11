{ ... }:

{
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Calcutta";
  i18n.defaultLocale = "en_US.UTF-8";
}
