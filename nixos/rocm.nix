{pkgs,pkgs-stable, ...}: {
  # Taken from https://theholytachanka.com/posts/setting-up-resolve/
  # Enable openGL and install Rocm
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs-stable; [
      rocmPackages_6.clr.icd
      rocmPackages_6.clr
      rocmPackages_6.rocminfo
      rocmPackages_6.rocm-runtime
    ];
  };
  # This is necesery because many programs hard-code the path to hip
  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages_6.clr}"
  ];
}
