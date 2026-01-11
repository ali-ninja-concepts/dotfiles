{ ... }:

{
  imports = [
    ../hardware-configuration.nix
    ./modules/system/boot.nix
    ./modules/system/nvidia.nix
    ./modules/system/audio.nix
    ./modules/system/networking.nix
    ./modules/system/nix.nix
    ./modules/services/postgres.nix
    ./modules/services/docker.nix
    ./modules/services/display.nix
    ./modules/users.nix
    ./modules/packages.nix
    ./modules/fonts.nix
  ];

  system.stateVersion = "24.05";
}
