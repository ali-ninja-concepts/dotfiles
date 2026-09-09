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
    sqlite
    ssm-session-manager-plugin

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
    nodejs_22
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
    # bitwarden-desktop: installed via Flatpak (com.bitwarden.desktop) — the
    # nixpkgs build pins an EOL electron-39.8.10.

    # VPN
    openvpn

    # Custom packages
    (pkgs.callPackage ../pkgs/opencode.nix {})
    (pkgs.callPackage ../pkgs/sidecar.nix {})
    (pkgs.callPackage ../pkgs/pi { })
    (pkgs.callPackage ../pkgs/hermes-agent.nix { })
    (pkgs.callPackage ../pkgs/slack-cli.nix { })
  ];
}
