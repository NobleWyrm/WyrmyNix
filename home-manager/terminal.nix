# ██╗  ██╗██╗████████╗████████╗██╗   ██╗
# ██║ ██╔╝██║╚══██╔══╝╚══██╔══╝╚██╗ ██╔╝
# █████╔╝ ██║   ██║      ██║    ╚████╔╝
# ██╔═██╗ ██║   ██║      ██║     ╚██╔╝
# ██║  ██╗██║   ██║      ██║      ██║
# ╚═╝  ╚═╝╚═╝   ╚═╝      ╚═╝      ╚═╝
{
  config,
  pkgs,
  pkgs-stable,
  lib,
  inputs,
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

  # Load in the nixvim flake to get the home-manager modules available
  imports = [inputs.nixvim.homeManagerModules.nixvim];
  # Get the packages required for language servers and other plugins
  home.packages = with pkgs; [
    pkgs-stable.nixd
    alejandra
    vimPlugins.nvim-treesitter
  ];
  # Necessary addition for nixd
  nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];
  programs.nixvim = {
    enable = true;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    # Have to use "+y to yank to the clipboard register
    # @TODO set up better keybinds to work with this.
    clipboard.providers.wl-copy.enable = true;

    opts = {
      number = true;
      cursorline = true;
      tabstop = 2;
      softtabstop = 2;
      expandtab = true;
      smartindent = true;
      breakindent = true;
      shiftwidth = 2;

      # Offset the screen scrolling so 10 lines are always above/below the cursor
      scrolloff = 10;

      # Disable the dang mouse support so I stop accidentally clicking
      mouse = "";
    };

    plugins = {
      lsp = {
        enable = true;
        servers = {
          #nixd.enable = true;
          ts_ls.enable = true;
          basedpyright.enable = true;
        };
      };
      lsp-format.enable = true;
      lsp-lines.enable = true;

      treesitter = {
        enable = true;

        settings = {
          indent.enable = true;
          highlight.enable = true;
        };

        grammarPackages = pkgs.vimPlugins.nvim-treesitter.allGrammars;
      };
    };
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
