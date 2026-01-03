{
  pkgs,
  pkgs-stable,
  ...
}: {
  virtualisation.incus = {
    enable = true;
    package = pkgs.incus;
  };
  networking.nftables.enable = true;
}
