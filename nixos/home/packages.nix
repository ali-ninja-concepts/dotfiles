{ pkgs, ... }:

{
  home.packages = with pkgs; [
    dunst
    clipcat
    i3lock
    dmenu
    feh
    maim
    xsel
    brightnessctl
    xss-lock
    pavucontrol
    nodejs_20
    slack
    code-cursor
  ];

  home.sessionVariables = {
    NPM_CONFIG_PREFIX = "$HOME/.npm-global";
  };

  home.sessionPath = [ "$HOME/bin" ];
}
