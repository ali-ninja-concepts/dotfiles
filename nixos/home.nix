{ config, pkgs, ... }:

{
  home.username = "ali-zahir";
  home.homeDirectory = "/home/ali-zahir";
  home.stateVersion = "24.05";

  xdg.configFile."autorandr.sh" = {
    source = ../scripts/autorandr.sh;
    executable = true;
  };

  home.file."bin/get-luks-uuid" = {
    source = ../scripts/get-luks-uuid.sh;
    executable = true;
  };

  home.sessionPath = [ "$HOME/bin" ];

  home.packages = with pkgs; [
    rofi
    dunst
    polybar
    clipcat
    i3status
    i3lock
    dmenu
    feh
    maim
    xsel
    parcellite
    brightnessctl
    xss-lock
    pavucontrol
  ];

  xsession.windowManager.i3 = {
    enable = true;
    config = {
      modifier = "Mod1";
      terminal = "kitty";
      
      fonts = {
        names = [ "JetBrains Mono" ];
        size = 12.0;
      };

      focus = {
        followMouse = false;
        forceWrapping = true;
      };

      floating.modifier = "Mod1";

      keybindings = let
        mod = "Mod1";
        refresh = "killall -SIGUSR1 i3status";
      in {
        "${mod}+Return" = "exec kitty";
        "${mod}+q" = "kill";
        "${mod}+d" = "exec dmenu_run";
        
        "${mod}+j" = "focus left";
        "${mod}+k" = "focus down";
        "${mod}+l" = "focus up";
        "${mod}+semicolon" = "focus right";
        
        "${mod}+Left" = "focus left";
        "${mod}+Down" = "focus down";
        "${mod}+Up" = "focus up";
        "${mod}+Right" = "focus right";
        
        "${mod}+Shift+j" = "move left";
        "${mod}+Shift+k" = "move down";
        "${mod}+Shift+l" = "move up";
        "${mod}+Shift+semicolon" = "move right";
        
        "${mod}+Shift+Left" = "move left";
        "${mod}+Shift+Down" = "move down";
        "${mod}+Shift+Up" = "move up";
        "${mod}+Shift+Right" = "move right";
        
        "${mod}+h" = "split h";
        "${mod}+v" = "split v";
        "${mod}+f" = "fullscreen toggle";
        
        "${mod}+s" = "layout stacking";
        "${mod}+w" = "layout tabbed";
        "${mod}+e" = "layout toggle split";
        
        "${mod}+Shift+space" = "floating toggle";
        "${mod}+space" = "focus mode_toggle";
        "${mod}+a" = "focus parent";
        "${mod}+Tab" = "workspace back_and_forth";
        
        "${mod}+1" = "workspace number 1";
        "${mod}+2" = "workspace number 2";
        "${mod}+3" = "workspace number 3";
        "${mod}+4" = "workspace number 4";
        "${mod}+5" = "workspace number 5";
        "${mod}+6" = "workspace number 6";
        "${mod}+7" = "workspace number 7";
        "${mod}+8" = "workspace number 8";
        "${mod}+9" = "workspace number 9";
        "${mod}+0" = "workspace number 10";
        
        "${mod}+Shift+1" = "move container to workspace number 1";
        "${mod}+Shift+2" = "move container to workspace number 2";
        "${mod}+Shift+3" = "move container to workspace number 3";
        "${mod}+Shift+4" = "move container to workspace number 4";
        "${mod}+Shift+5" = "move container to workspace number 5";
        "${mod}+Shift+6" = "move container to workspace number 6";
        "${mod}+Shift+7" = "move container to workspace number 7";
        "${mod}+Shift+8" = "move container to workspace number 8";
        "${mod}+Shift+9" = "move container to workspace number 9";
        "${mod}+Shift+0" = "move container to workspace number 10";
        
        "${mod}+Shift+c" = "reload";
        "${mod}+Shift+r" = "restart";
        "${mod}+r" = "mode resize";
        
        "${mod}+Shift+bracketright" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +5%";
        "${mod}+Shift+bracketleft" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -5%";
        "${mod}+bracketleft" = "exec --no-startup-id brightnessctl set 10%-";
        "${mod}+bracketright" = "exec --no-startup-id brightnessctl set +10%";
        
        "${mod}+Shift+s" = "exec maim -s ~/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png";
      };

      modes = {
        resize = {
          "j" = "resize shrink width 10 px or 10 ppt";
          "k" = "resize grow height 10 px or 10 ppt";
          "l" = "resize shrink height 10 px or 10 ppt";
          "semicolon" = "resize grow width 10 px or 10 ppt";
          "Left" = "resize shrink width 10 px or 10 ppt";
          "Down" = "resize grow height 10 px or 10 ppt";
          "Up" = "resize shrink height 10 px or 10 ppt";
          "Right" = "resize grow width 10 px or 10 ppt";
          "Return" = "mode default";
          "Escape" = "mode default";
        };
      };

      startup = [
        {
          command = "~/.config/autorandr.sh";
          always = true;
          notification = false;
        }
        { command = "nm-applet"; notification = false; }
        { command = "parcellite"; notification = false; }
        { command = "xss-lock --transfer-sleep-lock -- i3lock --nofork"; notification = false; }
      ];

      bars = [
        {
          statusCommand = "${pkgs.i3status}/bin/i3status";
        }
      ];
    };
  };

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

  programs.kitty = {
    enable = true;
    settings = {
      font_family = "JetBrains Mono";
      font_size = 12;
      enable_audio_bell = false;
      copy_on_select = "clipboard";
    };
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    
    oh-my-zsh = {
      enable = true;
      theme = "dpoggi";
      plugins = [ "git" ];
    };

    shellAliases = {
      ls = "eza";
      cat = "bat";
      ll = "eza -la";
      copy = "xsel --clipboard --input";
      p = "xsel --clipboard --output";
      rebuild = "sudo nixos-rebuild switch --flake /etc/nixos#nixos";
      update = "sudo nixos-rebuild switch --flake /etc/nixos#nixos --upgrade";
    };

    sessionVariables = {
      EDITOR = "nvim";
    };

    initExtra = ''
      # NVM
      export NVM_DIR="$HOME/.nvm"
      [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
      
      # Secrets
      [ -f ~/.secrets.env ] && source ~/.secrets.env
    '';
  };

  programs.git = {
    enable = true;
    userName = "Ali Zahir";
    userEmail = "ali@ninjaconcepts.ai";
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

  programs.home-manager.enable = true;
}
