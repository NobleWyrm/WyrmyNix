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
      mouse_hide_wait = 60;
    };
  };

  programs.starship = {
    enable = true;
    settings = {


    };
  };
}
