{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."cryptroot" = {
    device = "/dev/disk/by-uuid/YOUR-LUKS-UUID-HERE";
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

    displayManager.defaultSession = "none+i3";

    xkb = {
      layout = "us";
      variant = "";
    };
  };

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.displayManager.autoLogin = {
    enable = true;
    user = "ali-zahir";
  };

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  users.users.ali-zahir = {
    isNormalUser = true;
    description = "Ali Zahir";
    extraGroups = [ "networkmanager" "wheel" "video" "audio" "tss" ];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    git
    neovim
    wget
    curl
    kitty
    firefox
    google-chrome

    feh
    maim
    xsel
    parcellite
    brightnessctl
    xss-lock

    eza
    bat
    fzf
    ripgrep
    fd

    nodejs_20
    bun
    go

    pavucontrol
    networkmanagerapplet

    xorg.xrandr
    xorg.xinput

    tpm2-tools
  ];

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    fira-code
    fira-code-symbols
    jetbrains-mono
    (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" ]; })
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "24.05";
}
