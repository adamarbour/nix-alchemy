{ lib, config, ... }:
let
  inherit (lib) mkIf;
  cfg = config.alchemy.system.hardware;
in {
  config = mkIf (cfg.cpu == "intel") {
    hardware.cpu.intel.updateMicrocode = true;
    boot = {
      kernelModules = [ "kvm-intel" ];
      kernelParams = [
        "enable_gvt=1"
      ];
    };
  };
}
