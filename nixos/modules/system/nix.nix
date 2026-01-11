{ ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Automatic garbage collection (monthly)
  nix.gc = {
    automatic = true;
    dates = "monthly";
    options = "--delete-older-than 30d";
  };

  # Optimize store by hard-linking identical files
  nix.optimise.automatic = true;

  nixpkgs.config.allowUnfree = true;
}
