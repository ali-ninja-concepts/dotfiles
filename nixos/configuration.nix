{ ... }:

{
  imports = [
    ../hardware-configuration.nix
    ./modules/system/boot.nix
    ./modules/system/nvidia.nix
    ./modules/system/audio.nix
    ./modules/system/networking.nix
    ./modules/system/nix.nix
    ./modules/system/zram.nix
    ./modules/services/postgres.nix
    ./modules/services/docker.nix
    ./modules/services/display.nix
    ./modules/services/clamav.nix
    ./modules/services/ssh.nix
    ./modules/services/tailscale.nix
    ./modules/services/restic.nix
    ./modules/services/flatpak.nix
    ./modules/users.nix
    ./modules/packages.nix
    ./modules/fonts.nix
  ];

  system.stateVersion = "24.05";
}
