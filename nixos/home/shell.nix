{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    plugins = [
      {
        name = "zsh-interactive-cd";
        file = "zsh-interactive-cd.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "mrjohannchang";
          repo = "zsh-interactive-cd";
          rev = "master";
          sha256 = "j23Ew18o7i/7dLlrTu0/54+6mbY8srsptfrDP/9BI/Q=";
        };
      }
    ];

    oh-my-zsh = {
      enable = true;
      theme = "dpoggi";
      plugins = [ "git" "kitty" "zoxide" "colored-man-pages" "history-substring-search" "docker" "nvm" "npm" "tmux" ];
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
      PATH = "$HOME/.local/bin:$PATH";
    };

    initContent = ''
      # NPM global path
      export PATH="$HOME/.npm-global/bin:$PATH"

      # NVM
      export NVM_DIR="$HOME/.nvm"
      [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

      # Secrets
      [ -f ~/.secrets.env ] && source ~/.secrets.env
    '';
  };
}
