# ██╗  ██╗██╗████████╗████████╗██╗   ██╗
# ██║ ██╔╝██║╚══██╔══╝╚══██╔══╝╚██╗ ██╔╝
# █████╔╝ ██║   ██║      ██║    ╚████╔╝
# ██╔═██╗ ██║   ██║      ██║     ╚██╔╝
# ██║  ██╗██║   ██║      ██║      ██║
# ╚═╝  ╚═╝╚═╝   ╚═╝      ╚═╝      ╚═╝
{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.kitty = {
    enable = true;
    settings = {
      # Gets rid of the annoying confirmation on close.
      # No kitty, I don't care if there is an inactive bash session, just kill the pane!
      confirm_os_window_close = 0;
      background_opacity = lib.mkForce "0.75";
      window_padding_width = 10;
      scrollback_lines = 10000;
      enable_audio_bell = false;
      mouse_hide_wait = 5;
    };
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
  
    shellAliases = {
      ll = "ls -l";
      kali = "ssh kali";
      #update = "sudo nixos-rebuild switch";
    };
    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };
  
  };

  programs.starship = {
    enable = true;
    settings = {

    };
  };

  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      style = "compact";
    };
    flags = [
      '--disable-up-arrow'
    ];
  };
}
