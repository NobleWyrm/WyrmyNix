{pkgs,...}: {
  imports = [
    ./hardware-configuration.nix
    ./bootloader.nix
    ./displaymanager.nix
    ./pipewire.nix
    ./rocm.nix
  ];

  networking.hostName = "WyrmNix"; # Define your hostname.


  services.gnome.gnome-keyring.enable = true;


  stylix.enable = true;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-dark.yaml";
  #stylix.override = {
  #  base00 =
  #}
  #stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/gigavolt.yaml";
  #stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-frappe.yaml";

  #stylix.polarity = "dark";
  stylix.image = ./wallpaper.png;


  security.pam.services.hyprlock = {};

  services.logind.lidSwitch = "suspend-then-hibernate";
  # Is this worth doing? Dunno, let's find out.
  #powerManagement.enable = true;
  services.power-profiles-daemon.enable = true;

  # Install firefox.
  programs.firefox.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  environment.systemPackages = with pkgs; [

    freerdp

    # Terminals
    kitty
    #foot

    brightnessctl
    # This is the section for hyprland, eventually gonna put this in its own config file
    hyprland
    hyprlock
    hypridle
    waybar
    dunst
    libnotify
    swww
    rofi
    grimblast
    #(flameshot.override { enableWlrSupport = true; })
    #kdePackages.xwaylandvideobridge
    xorg.xhost

    lutris
  ];

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [
    pkgs.xdg-desktop-portal-gtk
    pkgs.xdg-desktop-portal-hyprland
    pkgs.xdg-desktop-portal-wlr
  ];

  services.openvpn.servers = {
    homeVPN = {
      autoStart = true;
      config = ''config /home/bwyrm/VPNs/pfSense-sec-UDP4-11194-majikguy-config.ovpn '';
      updateResolvConf = true; # maybe this line could fix it
    };
  };
}
