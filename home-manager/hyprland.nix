{
  nix-config,
  pkgs,
  lib,
  ...
}: {
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mod" = "SUPER";
      "$terminal" = "kitty";
      "$menu" = "rofi -show drun -show-icons";

      exec-once = [
        "sleep 5; swww-daemon"
        "waybar"
        "steam -silent"
      ];

      monitor = [
        ",highres,auto,1"
      ];

      input = {
        kb_layout = "us";
        repeat_rate = 50;
        repeat_delay = 300;

        accel_profile = "flat";
        follow_mouse = 1;
        sensitivity = 0.5;
        mouse_refocus = false;

        touchpad = {
          natural_scroll = true;
          scroll_factor = 0.2;
          disable_while_typing = false;
        };
      };

      general = {
        gaps_in = 10;
        gaps_out = 10;
        border_size = 2;
        layout = "master";
      };

      decoration = {
        rounding = 10;
        drop_shadow = true;
        shadow_range = 30;
        shadow_render_power = 3;

        blur = {
          enabled = true;
          size = 4;
          passes = 2;
        };
      };

      misc = {
        disable_splash_rendering = true;
        disable_hyprland_logo = true;
      };

      bind =
        [
          "$mod, T, exec, $terminal"
          "$mod, Return, exec, $menu"

          # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
          "$mod, Escape, killactive,"
          "$mod, M, exit,"
          "$mod, E, exec, $fileManager"
          "$mod, V, togglefloating,"
          "$mod, R, exec, $menu"
          "$mod, P, pseudo, # dwindle"
          "$mod, J, togglesplit, # dwindle"

          #", Print, exec, grimblast copy area"
          # Move focus with mainMod + arrow keys
          "$mod, left, movefocus, l"
          "$mod, right, movefocus, r"
          "$mod, up, movefocus, u"
          "$mod, down, movefocus, d"
          # Move focus with mainMod + vim keys
          "$mod, h, movefocus, l"
          "$mod, l, movefocus, r"
          "$mod, k, movefocus, u"
          "$mod, j, movefocus, d"

          # Laptop multimedia keys for volume and LCD brightness
          ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
          ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
          ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
          ",XF86MonBrightnessUp, exec, brightnessctl s 10%+"
          ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"
        ]
        ++ (
          # workspaces
          # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
          builtins.concatLists (builtins.genList (
              i: let
                ws = i + 1;
              in [
                "$mod, code:1${toString i}, workspace, ${toString ws}"
                "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
              ]
            )
            9)
        );
    };
  };
}
