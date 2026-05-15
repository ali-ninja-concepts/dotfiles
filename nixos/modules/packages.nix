{ pkgs, ... }:

{
  hardware.i2c.enable = true;

  environment.systemPackages = with pkgs; [
    # Core
    git
    neovim
    nixd
    wget
    curl
    kitty
    jq
    ouch
    tmux
    ncdu

    # Desktop
    google-chrome
    onlyoffice-desktopeditors
    thunar
    thunar-volman
    gvfs
    lxappearance
    polkit_gnome
    obsidian
    postman
    spotify
    rpi-imager

    # i3 utilities
    feh
    maim
    xsel
    brightnessctl
    ddcutil
    xss-lock
    arandr

    # CLI tools
    eza
    bat
    fzf
    ripgrep
    fd
    yt-dlp
    ffmpeg
    nmap
    dnsutils  # dig, nslookup, host

    # Development
    nodejs_20
    bun
    go
    pnpm
    python3
    uv
    dbgate
    flutter
    jdk
    maven
    gcc
    gnumake

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
    xrandr
    xinput

    # Security
    tpm2-tools
    bitwarden-desktop

    # VPN
    openvpn

    # Custom packages
    (pkgs.callPackage ../pkgs/opencode.nix {})
    (pkgs.callPackage ../pkgs/sidecar.nix {})
  ];
}
