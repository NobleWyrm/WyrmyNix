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

      format = lib.concatStrings [
        "[](${base03})"
	"[ ](fg:${base08} bg:${base03})"
	"[ ](fg:${base03} bg:${base02})"
        "$directory"
	"[ ](fg:${base02} bg:${base00})"
        "$git_branch"
        "$git_status"
        "$rust"
	"$fill"
	"[](fg:${base03} bg:${base00})"
        "$time"
	"[](fg:${base03} bg:${base00})"
        "\n"
        "$character"
      ];

      directory = {
	format = "[$path]($style)";
        style = "fg:${base07} bg:${base02}";
        truncation_length = 5;
        truncation_symbol = "…/";
      };

      time = {
        disabled = false;
	format = "[$time]($style)";
	time_format = "%R";
        style = "fg:${base07} bg:${base03}";
      };

      rust = {
        symbol = "󱘗";
        format = "[$symbol($version)]($style)";
      };

      fill.symbol = " ";
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
