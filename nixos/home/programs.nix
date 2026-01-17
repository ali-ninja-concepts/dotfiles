{ ... }:

{
  programs.kitty = {
    enable = true;
    settings = {
      font_family = "JetBrains Mono";
      font_size = 12;
      enable_audio_bell = false;
      copy_on_select = "clipboard";
    };
  };

  programs.git = {
    enable = true;
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

  # SSH client with keepalive to prevent connection timeouts
  programs.ssh = {
    enable = true;
    matchBlocks."*" = {
      serverAliveInterval = 60;  # Send keepalive every 60 seconds
      serverAliveCountMax = 3;   # Disconnect after 3 missed keepalives
    };
  };
}
