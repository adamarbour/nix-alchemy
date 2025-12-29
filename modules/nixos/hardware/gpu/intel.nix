{ lib, pkgs, config, ... }:
let
  inherit (lib) mkIf;
  cfg = config.alchemy.system.hardware;
in {
  config = mkIf (cfg.gpu == "intel") {
    # i915 kernel module
    boot.initrd.kernelModules = [ "i915" ];
    boot.kernelParams = [ "i915.fastboot=1" ];
    # we enable modesetting since this is recomeneded for intel gpus
    services.xserver.videoDrivers = [ "modesetting" ];
    
    # OpenCL support and VAAPI
    hardware.graphics = {
      extraPackages = with pkgs; [
        intel-media-driver
        intel-compute-runtime
        vpl-gpu-rt
      ];

      extraPackages32 = with pkgs.pkgsi686Linux; [
        intel-media-driver
      ];
    };
  };
}
