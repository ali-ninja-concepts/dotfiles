{ pkgs, ... }:

{
  users.users.ali-zahir = {
    isNormalUser = true;
    description = "Ali Zahir";
    extraGroups = [ "networkmanager" "wheel" "video" "audio" "tss" "docker" "i2c" ];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;
  programs.nix-ld.enable = true;
}
