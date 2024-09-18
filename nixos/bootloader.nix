{ pkgs, ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.luks.devices."luks-c3413beb-aea3-4010-b9f4-61f9abd8ff1e".device = "/dev/disk/by-uuid/c3413beb-aea3-4010-b9f4-61f9abd8ff1e";
  boot.plymouth = {
    enable = true;
    font = "${pkgs.jetbrains-mono}/share/fonts/truetype/JetBrainsMono-Regular.ttf";
  };
}
