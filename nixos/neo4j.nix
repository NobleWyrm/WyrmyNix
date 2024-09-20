{
  pkgs,
  config,
  lib,
  ...
}:
{
  #options.modules.neo4j = {enable = mkEnableOption "neo4j";};
  services.neo4j = {
    enable = true;
    bolt = {
      enable = true;
      tlsLevel = "DISABLED";
      listenAddress = "127.0.0.1:7687";
    };
    http = {
      enable = true;
      listenAddress = "127.0.0.1:7474";
    };
    https.enable = false;
  };
  #systemd.services.neo4j.wantedBy = lib.mkForce [];
}
