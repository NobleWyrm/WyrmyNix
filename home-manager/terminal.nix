# ██╗  ██╗██╗████████╗████████╗██╗   ██╗
# ██║ ██╔╝██║╚══██╔══╝╚══██╔══╝╚██╗ ██╔╝
# █████╔╝ ██║   ██║      ██║    ╚████╔╝
# ██╔═██╗ ██║   ██║      ██║     ╚██╔╝
# ██║  ██╗██║   ██║      ██║      ██║
# ╚═╝  ╚═╝╚═╝   ╚═╝      ╚═╝      ╚═╝
{
  config,
  pkgs, pkgs-stable, lib,
  ...
}: {
  programs.kitty = {
    enable = true;
    settings = {
      # Gets rid of the annoying confirmation on close.
      # No kitty, I don't care if there is an inactive bash session, just kill the pane!
      confirm_os_window_close = 0;
      shell = "zsh";
      background_opacity = lib.mkForce "0.80";
      window_padding_width = 10;
      scrollback_lines = 10000;
      enable_audio_bell = false;
      mouse_hide_wait = 5;
    };
  };

  programs.neovim = {
    enable = true;

    plugins = with pkgs.vimPlugins; [
      base16-nvim
    ];
  };

  # Added here just to tie into stylix
  programs.btop.enable = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    defaultKeymap = "emacs";
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
    settings = with config.lib.stylix.colors.withHashtag; {
      add_newline = false;
      username = {
        show_always = true;
        format = lib.concatStrings [
#	  "[░▒▓](fg:${base03} bg:${base00})"
	  "[ $user]($style)"
	  "[ ](fg:${base03} bg:${base00})"
	];
        style_user = "fg:${base07} bg:${base03}";
      };
    };
  };

  programs.tmux = {
    enable = true;

  };

  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      vim = true;
      search_mode = "fuzzy";
      filter_mode = "host";
    };
    flags = [
      "--disable-up-arrow"
    ];
  };
}
