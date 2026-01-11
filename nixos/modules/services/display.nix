{ pkgs, ... }:

{
  services.xserver = {
    enable = true;

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

  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "ali-zahir";

  # Keyring for secrets (required by mybar)
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.lightdm.enableGnomeKeyring = true;
}
