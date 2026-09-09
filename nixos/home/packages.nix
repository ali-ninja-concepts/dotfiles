{ pkgs, inputs, ... }:

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
    nodejs_22
    slack
    code-cursor
    zoxide
    simple-http-server
    gh
    supabase-cli
    stripe-cli
    awscli2
    turso-cli
    vlc
    livekit-cli
    duckdb
    glow
    mdcat
    sox
    obs-studio
    libimobiledevice
    ifuse
    inputs.herdr.packages.${pkgs.system}.default
  ];

  home.sessionVariables = {
    NPM_CONFIG_PREFIX = "$HOME/.npm-global";
  };

  home.sessionPath = [ "$HOME/bin" ];
}
