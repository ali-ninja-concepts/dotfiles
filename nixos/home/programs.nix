{ pkgs, ... }:

let
  # Launch kitty into a tmux session: attach to the first unattached
  # "kitty-N" session, or create the next free one. Combined with
  # tmux-continuum, this gives reboot-surviving shells per kitty window.
  kitty-tmux = pkgs.writeShellScriptBin "kitty-tmux" ''
    set -u
    TMUX_BIN=${pkgs.tmux}/bin/tmux
    i=1
    while "$TMUX_BIN" has-session -t "kitty-$i" 2>/dev/null; do
      if [ -z "$("$TMUX_BIN" list-clients -t "kitty-$i" 2>/dev/null)" ]; then
        exec "$TMUX_BIN" attach-session -t "kitty-$i"
      fi
      i=$((i+1))
    done
    exec "$TMUX_BIN" new-session -s "kitty-$i"
  '';
in
{
  home.packages = [ kitty-tmux ];

  programs.kitty = {
    enable = true;
    settings = {
      font_family = "JetBrains Mono";
      font_size = 12;
      enable_audio_bell = false;
      copy_on_select = "clipboard";
      shell = "${kitty-tmux}/bin/kitty-tmux";
    };
  };

  programs.git = {
    enable = true;
    lfs.enable = true;
    settings.user.name = "Ali Zahir";
    settings.user.email = "ali@ninjaconcepts.ai";
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  # direnv for automatic dev environment activation
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.tmux = {
    enable = true;
    mouse = true;                  # click to switch panes/windows, scroll works
    baseIndex = 1;                 # windows start at 1, not 0
    escapeTime = 0;                # no delay after pressing Escape
    historyLimit = 10000;          # scrollback buffer
    terminal = "tmux-256color";
    plugins = with pkgs.tmuxPlugins; [
      resurrect                    # Ctrl+b Ctrl+s to save, Ctrl+b Ctrl+r to restore
      continuum                    # auto-saves sessions every 15 min
    ];
    extraConfig = ''
      # Auto-restore saved sessions
      set -g @continuum-restore 'on'

      # Pass terminal focus events through to apps (Claude Code, vim, etc.)
      set -g focus-events on

      # Easier window creation: Ctrl+b Enter (close to what you're used to)
      bind Enter new-window

      # Status bar - keep it simple
      set -g status-style 'bg=default,fg=white'
      set -g status-left '#[fg=green]#S '
      set -g status-right ''''
    '';
  };

  # SSH client with keepalive to prevent connection timeouts
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks."*" = {
      serverAliveInterval = 60;  # Send keepalive every 60 seconds
      serverAliveCountMax = 3;   # Disconnect after 3 missed keepalives
    };
    matchBlocks."personal-github" = {
      hostname = "github.com";
      identityFile = "~/.ssh/id_ed25519_personal";
      identitiesOnly = true;
    };
  };
}
