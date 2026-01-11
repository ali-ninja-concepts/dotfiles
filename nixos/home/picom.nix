{ ... }:

{
  services.picom = {
    enable = true;
    backend = "glx";
    vSync = true;

    shadow = true;
    shadowOpacity = 0.75;

    fade = true;
    fadeDelta = 5;

    settings = {
      corner-radius = 0;
      detect-rounded-corners = true;
      glx-no-stencil = true;
      glx-copy-from-front = false;
      use-damage = true;
      xrender-sync-fence = true;
    };
  };
}
