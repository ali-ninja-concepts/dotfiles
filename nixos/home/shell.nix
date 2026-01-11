{ ... }:

{
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
