{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Core
    git
    neovim
    nixd
    wget
    curl
    kitty
    jq

    # Desktop
    google-chrome
    onlyoffice-desktopeditors
    thunar
    thunar-volman
    gvfs
    lxappearance
    polkit_gnome

    # i3 utilities
    feh
    maim
    xsel
    brightnessctl
    xss-lock
    arandr

    # CLI tools
    eza
    bat
    fzf
    ripgrep
    fd
    yt-dlp

    # Development
    nodejs_20
    bun
    go
    pnpm
    dbgate

    # Audio
    pavucontrol
    pulseaudio  # provides pactl CLI
    networkmanagerapplet

    # mybar dependencies
    gnome-keyring
    libsecret
    gsimplecal
    xfce4-taskmanager

    # X11
    xorg.xrandr
    xorg.xinput

    # Security
    tpm2-tools

    # Custom packages
    (pkgs.callPackage ../pkgs/opencode.nix {})
  ];
}
