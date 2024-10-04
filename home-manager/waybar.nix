{
  config,
  pkgs,
  ...
}: {
  programs.waybar.enable = true;

  programs.waybar.settings = {
    mainBar = {
      layer = "top";
      position = "top";
      height = 26;
      output = [
        "eDP-1"
      ];

      modules-left = ["custom/logo" "hyprland/workspaces" "hyprland/mode"];
      modules-right = ["privacy" "wireplumber" "network" "tray" "clock" "battery"];

      "custom/logo" = {
        format = "";
        tooltip = false;
        #on-click = ''bemenu-run --accept-single  -n -p "Launch" --hp 4 --hf "#ffffff" --sf "#ffffff" --tf "#ffffff" '';
      };

      "clock" = {
        interval = 60;
        format = "{:%a %m/%d | %I:%M}";
        tooltip = false;
        #tooltip-format = "{:%A, %B %d, %Y (%R)}  ";
      };

      "wireplumber" = {
        format = "{volume}%";
        format-muted = "";
        #on-click = "helvum";
	on-click = "pwvucontrol";
        max-volume = 100;
        scroll-step = 0.2;
      };

      "battery" = {
        interval = 60;
        states = {
          warning = 30;
          critical = 15;
        };
        format = "{capacity}% {icon}";
        format-icons = ["" "" "" "" ""];
        max-length = 25;
      };

      "network" = {
        interface = "wlp1s0";
        format = "{ifname}";
        format-wifi = "{essid} ({signalStrength}%)  ";
        format-ethernet = "{ipaddr}/{cidr} 󰊗 ";
        format-disconnected = ""; #An empty format will hide the module.
        tooltip-format = "{ifname} via {gwaddr} 󰊗 ";
        tooltip-format-wifi = "{essid} ({signalStrength}%)  ";
        tooltip-format-ethernet = "{ifname}  ";
        tooltip-format-disconnected = "Disconnected";
        max-length = 50;
      };

      "tray" = {
        icon-size = 16;
        spacing = 10;
      };

      "privacy" = {
        icon-spacing = 4;
        icon-size = 18;
        transition-duration = 250;
        modules = [
          {
            type = "screenshare";
            tooltip = true;
            tooltip-icon-size = 24;
          }
          {
            type = "audio-in";
            tooltip = true;
            tooltip-icon-size = 24;
          }
        ];
      };
    };
  };

  programs.waybar.style = ''

    * {
      border: none;
      border-radius: 0;
      padding: 0;
      margin: 0;
      font-size: 11px;
    }

    #custom-logo {
      font-size: 18px;
      margin: 0;
      margin-left: 7px;
      margin-right: 16px;
      padding: 0;
      font-family: NotoSans Nerd Font Mono;
    }

    #workspaces button {
      margin-right: 10px;
    }

    #language {
      margin-right: 7px;
    }

    #battery {
      margin-left: 7px;
      margin-right: 15px;
    }
  '';
}
