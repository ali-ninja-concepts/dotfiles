{ pkgs, ... }:

let
  # Define a Chrome "app mode" PWA. Produces both:
  #   - a .desktop entry (for WM / app launchers that read .desktop files)
  #   - an executable on PATH named `name` (so PATH-scanning launchers like
  #     dmenu-recent list it)
  mkWebApp = { name, desktopName, url, icon ? null }:
    let
      launcher = pkgs.writeShellScriptBin name ''
        exec ${pkgs.google-chrome}/bin/google-chrome-stable \
          --app=${url} \
          --class=${desktopName} "$@"
      '';
      desktopItem = pkgs.makeDesktopItem {
        inherit name desktopName icon;
        exec = "${launcher}/bin/${name}";
        startupWMClass = desktopName;
        categories = [ "Network" ];
      };
    in
    [ launcher desktopItem ];

  linear = mkWebApp {
    name = "linear";
    desktopName = "Linear";
    url = "https://linear.app";
    icon = "linear"; # drop a linear.png in ~/.local/share/icons/ to get an icon
  };
in
{
  home.packages = linear;
}
