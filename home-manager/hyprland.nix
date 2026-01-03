{
  nix-config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  programs.hyprlock.enable = true;
  programs.rofi.enable = true;

  stylix.cursor.package = inputs.rose-pine-hyprcursor.packages.${pkgs.stdenv.hostPlatform.system}.default;

  stylix.cursor.size = 1;
  stylix.cursor.name = "BreezX-RosePine-Linux";

  services.hypridle.enable = true;
  services.hypridle.settings = {
    general = {
      lock_cmd = "pidof hyprlock || hyprlock";
      before_sleep_cmd = "loginctl lock-session";
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mod" = "SUPER";
      "$terminal" = "kitty";
      "$lockscreen" = "loginctl lock-session";
      "$menu" = "rofi -show drun -show-icons";
      "$raw_run" = "rofi -show run";

      exec-once = [
        "sleep 0.1; swww-daemon"
        "sleep 0.75; waybar"
        "sleep 2; steam -silent"
      ];

      monitor = [
        #",highres,auto,1.25"
      ];

      xwayland = {
        force_zero_scaling = true;
      };

      cursor = {
        no_warps = true;
      };

      input = {
        kb_layout = "us";
        repeat_rate = 50;
        repeat_delay = 300;

        accel_profile = "flat";
        follow_mouse = 1;
        sensitivity = 0.5;
        mouse_refocus = false;

        # Should fix the issue I'm seeing with the detached numpad of the Framework 16 getting out of sync
        kb_options = numpad:mac;
        numlock_by_default = true;

        touchpad = {
          natural_scroll = true;
          scroll_factor = 0.2;
          disable_while_typing = false;
        };
      };

      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 1;
        layout = "master";
      };

      decoration = {
        rounding = 5;
        # The shadow settings were moved to a subsection
        shadow = {
          enabled = true;
          range = 30;
          render_power = 3;
        };

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
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod SHIFT, mouse:272, resizewindow"
      ];
      bind =
        [
          "$mod, T, exec, $terminal"
          "$mod, Return, exec, $terminal"
          "$mod, Space, exec, $menu"
          "$mod SHIFT, Return, exec, $raw_run"

          # Printscreen, flameshot even though it's slower?
          #", Print, exec, flameshot full -c"
          ", Print, exec, grimblast copy screen"
          "$mod SHIFT, s, exec, grimblast copy area"
          "$mod SHIFT CTRL, s, exec, grimblast save area"

          # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
          "$mod, Escape, killactive,"
          "$mod, M, exit,"
          "$mod, E, exec, $fileManager"
          "$mod, V, togglefloating,"
          "$mod, R, exec, $menu"
          "$mod, F, fullscreen"
          "$mod, P, pseudo, # dwindle"
          "$mod, J, togglesplit, # dwindle"
          "$mod CTRL, L, exec, $lockscreen"

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
          # Reorder windows
          "$mod SHIFT, left, movewindow, l"
          "$mod SHIFT, right, movewindow, r"
          "$mod SHIFT, up, movewindow, u"
          "$mod SHIFT, down, movewindow, d"
          "$mod SHIFT, h, movewindow, l"
          "$mod SHIFT, l, movewindow, r"
          "$mod SHIFT, k, movewindow, u"
          "$mod SHIFT, j, movewindow, d"

          # Laptop multimedia keys for volume and LCD brightness
          ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
          ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
          ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
          ",XF86AudioPlay, exec, playerctl play-pause"
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
