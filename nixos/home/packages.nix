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
    xidlehook
    pavucontrol
    nodejs_20
    slack
    code-cursor
    zoxide
    simple-http-server
    gh
    supabase-cli
  ];

  home.sessionVariables = {
    NPM_CONFIG_PREFIX = "$HOME/.npm-global";
  };

  home.sessionPath = [ "$HOME/bin" ];
}
