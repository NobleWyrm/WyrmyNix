{pkgs, ...}: {
  # Taken from https://theholytachanka.com/posts/setting-up-resolve/
  # Enable openGL and install Rocm
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      rocmPackages_5.clr.icd
      rocmPackages_5.clr
      rocmPackages_5.rocminfo
      rocmPackages_5.rocm-runtime
    ];
  };
  # This is necesery because many programs hard-code the path to hip
  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages_5.clr}"
  ];
}
