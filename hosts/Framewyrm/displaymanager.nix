{
  pkgs,
  inputs,
  ...
}: {
  # Enable Display Manager
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet -g 'Darest thou enter thine password?' --time --time-format '%I:%M %p | %a • %h | %F' --cmd Hyprland";
        user = "greeter";
      };
    };
  };

  environment.systemPackages = [
    pkgs.greetd.tuigreet
    #inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default
  ];
}
