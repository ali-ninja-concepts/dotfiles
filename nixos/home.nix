{ ... }:

{
  imports = [
    ./home/i3.nix
    ./home/picom.nix
    ./home/shell.nix
    ./home/programs.nix
    ./home/packages.nix
    ./home/services.nix
  ];

  home.username = "ali-zahir";
  home.homeDirectory = "/home/ali-zahir";
  home.stateVersion = "24.05";

  xsession.enable = true;
  xsession.initExtra = ''
    [ -f ~/.secrets.env ] && source ~/.secrets.env
  '';

  programs.home-manager.enable = true;
}
