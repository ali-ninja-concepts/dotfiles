{ config, pkgs, ... }:

{
  imports = [
    ../hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."cryptroot" = {
    device = "/dev/disk/by-uuid/27cc1d8e-916e-4704-895f-417b48423465";
    preLVM = true;
    allowDiscards = true;
  };

  security.tpm2 = {
    enable = true;
    pkcs11.enable = true;
    tctiEnvironment.enable = true;
  };

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Calcutta";
  i18n.defaultLocale = "en_US.UTF-8";

  services.xserver = {
    enable = true;

    videoDrivers = [ "nvidia" ];

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu
        i3status
        i3lock
      ];
    };

    xkb = {
      layout = "us";
      variant = "";
    };
  };

  services.xserver.displayManager.lightdm.enable = true;
  services.displayManager.defaultSession = "none+i3";

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = true;  # RTX 50xx series requires open kernel modules
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "ali-zahir";

  # Audio via PipeWire (modern replacement for PulseAudio)
  services.pipewire = {
    enable = true;
    audio.enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
  };

  # PostgreSQL 16 for local development ONLY
  # Uses trust auth on localhost - do not expose externally
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_16;
    enableTCPIP = true;
    authentication = pkgs.lib.mkOverride 10 ''
      # TYPE  DATABASE        USER            ADDRESS                 METHOD
      local   all             all                                     trust
      host    all             all             127.0.0.1/32            trust
      host    all             all             ::1/128                 trust
    '';
  };

  # Docker for development containers
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
  };

  users.users.ali-zahir = {
    isNormalUser = true;
    description = "Ali Zahir";
    extraGroups = [ "networkmanager" "wheel" "video" "audio" "tss" "docker" ];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;
  programs.nix-ld.enable = true;

  # Keyring for secrets (required by mybar)
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.lightdm.enableGnomeKeyring = true;

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    git
     neovim
     nixd
     wget
    curl
    kitty
    google-chrome
    jq
    onlyoffice-desktopeditors

    feh
    maim
    xsel
    brightnessctl
    xss-lock
    arandr

    eza
    bat
    fzf
    ripgrep
    fd

    nodejs_20
    bun
    go
    pnpm
    dbgate

    pavucontrol
    pulseaudio # provides pactl CLI
    networkmanagerapplet

    # File management
    thunar
    thunar-volman
    gvfs

    # Desktop essentials (no DE)
    lxappearance
    polkit_gnome

    # mybar dependencies
    gnome-keyring
    libsecret
    gsimplecal
    xfce4-taskmanager

    xorg.xrandr
    xorg.xinput

    tpm2-tools
   
    # Custom packages
    (pkgs.callPackage ./pkgs/opencode.nix {})

 ];

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    fira-code
    fira-code-symbols
    jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "24.05";
}
