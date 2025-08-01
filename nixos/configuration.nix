# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
# config,
  pkgs,
# pkgs-stable,
# lib,
# inputs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./bootloader.nix
    ./displaymanager.nix
    # Required for hashcat and other GPU compute functionality on AMD hardware
    ./rocm.nix

    ./pipewire.nix

    #./neo4j.nix
  ];

  nixpkgs.overlays = [
    (
      self: super: {
        kerbrute-go = super.callPackage ../packages/kerbrute-go {}; # path containing default.nix
      }
    )
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Bootloader.
  #boot.loader.systemd-boot.enable = true;
  #boot.loader.efi.canTouchEfiVariables = true;

  #boot.initrd.luks.devices."luks-c3413beb-aea3-4010-b9f4-61f9abd8ff1e".device = "/dev/disk/by-uuid/c3413beb-aea3-4010-b9f4-61f9abd8ff1e";

  networking.hostName = "WyrmNix"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  #This apparently helps with WiFi stability.
  hardware.enableRedistributableFirmware = true;

  services.gnome.gnome-keyring.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  fonts.packages = with pkgs; [
    font-awesome
    # nerdfonts was split out into separate packages for each individual font
    # This is kinda nice, but also means I have to go font by font.
    #nerdfonts
    nerd-fonts.jetbrains-mono
  ];

  stylix.enable = true;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-dark.yaml";
  #stylix.override = {
  #  base00 = 
  #}
  #stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/gigavolt.yaml";
  #stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-frappe.yaml";
  
  #stylix.polarity = "dark";
  stylix.image = ./wallpaper.png;

  # Configure keymap in X11
  #services.xserver.xkb = {
  #  layout = "us";
  #  variant = "";
  #};

  # Enable CUPS to print documents.
  services.printing.enable = true;

  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  # Turn on docker! I'm sure I won't get annoyed by this in the future.
  virtualisation.docker.enable = true;

  # Bad funky hack to make /etc/hosts writable, so that I can edit it (still as root) for Hack the Box and such.
  # I bet there's a way to spin up temporary shell environments with additonal hosts added in an overlay or something
  # Not gonna waste time on that now, gotta practice the hackin'
  environment.etc.hosts.mode = "0644";

  # Security / Polkit
  security.rtkit.enable = true;
  security.polkit.enable = true;
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (
        subject.isInGroup("users")
          && (
            action.id == "org.freedesktop.login1.reboot" ||
            action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
            action.id == "org.freedesktop.login1.power-off" ||
            action.id == "org.freedesktop.login1.power-off-multiple-sessions"
          )
        )
      {
        return polkit.Result.YES;
      }
    })
  '';

  services.logind.lidSwitch = "suspend-then-hibernate";
  # Is this worth doing? Dunno, let's find out.
  #powerManagement.enable = true;
  services.power-profiles-daemon.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.bwyrm = {
    isNormalUser = true;
    description = "Brian Wyrm";
    extraGroups = ["networkmanager" "wheel" "plugdev"];
    # Choosing to leave the default as bash and use zsh for kitty
    # This way I don't have to worry about my TTYs breaking in weird ways.
    # Might change it back later though, we'll see. Could find a better way.
    #shell = pkgs.zsh;
  };

  environment.shellAliases = {
    #vim = "nvim";
  };
  environment.variables.EDITOR = "nvim";
  programs.zsh.enable = true;

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    unzip
    p7zip
    file

    vim
    neovim

    tmux
    zellij
    jdk
    git
    btop
    killall
    powertop
    neofetch
    python3
    pipx

    openvpn
    freerdp

    # Terminals
    kitty
    #foot

    brightnessctl
    # This is the section for hyprland, eventually gonna put this in its own config file
    hyprland
    hyprlock
    waybar
    dunst
    libnotify
    swww
    rofi-wayland
    grimblast
    #(flameshot.override { enableWlrSupport = true; })
    kdePackages.xwaylandvideobridge
    xorg.xhost
  ];

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [
    pkgs.xdg-desktop-portal-gtk
    pkgs.xdg-desktop-portal-hyprland
    pkgs.xdg-desktop-portal-wlr
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  #services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;

  # This should automatically handle running the home VPN
  services.openvpn.servers = {
    homeVPN = {
      autoStart = true;
      config = '' config /home/bwyrm/VPNs/pfSense-sec-UDP4-11194-majikguy-config.ovpn '';
      updateResolvConf = true; # maybe this line could fix it
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
