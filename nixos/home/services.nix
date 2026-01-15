{ pkgs, ... }:

{
  services.xidlehook = {
    enable = true;
    not-when-fullscreen = true;
    not-when-audio = true;
    timers = [
      {
        delay = 900;
        command = "${pkgs.i3lock}/bin/i3lock -c 000000";
      }
    ];
  };
  xdg.configFile."autorandr.sh" = {
    source = ../../scripts/autorandr.sh;
    executable = true;
  };

  xdg.configFile."clipcat/clipcatd.toml" = {
    force = true;
    text = ''
      daemonize = true
      max_history = 50
      synchronize_selection_with_clipboard = true
      history_file_path = "/home/ali-zahir/.cache/clipcat/clipcatd-history"

      [log]
      emit_journald = true
      emit_stdout = false
      emit_stderr = false
      level = "INFO"

      [watcher]
      enable_clipboard = true
      enable_primary = true
      filter_text_min_length = 1
      filter_text_max_length = 20000000
      capture_image = false

      [grpc]
      enable_http = true
      enable_local_socket = true
      host = "127.0.0.1"
      port = 45045

      [desktop_notification]
      enable = true
      icon = "accessories-clipboard"
      timeout_ms = 2000
    '';
  };

  xdg.configFile."clipcat/clipcat-menu.toml" = {
    force = true;
    text = ''
      finder = "dmenu"
      preview_length = 80

      [dmenu]
      line_length = 100
      menu_length = 30
      menu_prompt = "Clipcat"
      extra_arguments = []
    '';
  };

  home.file."bin/get-luks-uuid" = {
    source = ../../scripts/get-luks-uuid.sh;
    executable = true;
  };

  home.file."bin/mybar" = {
    source = ../../bin/mybar;
    executable = true;
  };

  home.file."bin/dmenu-recent" = {
    source = ../../scripts/dmenu-recent.sh;
    executable = true;
  };
}
