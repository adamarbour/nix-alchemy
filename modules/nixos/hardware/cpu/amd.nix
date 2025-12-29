{ lib, config, ... }:
let
  inherit (lib) mkIf;
  cfg = config.alchemy.system.hardware;
in {
  config = mkIf (cfg.cpu == "amd") {
    hardware.cpu.amd.updateMicrocode = true;
    
    boot = {
      kernelModules = [ "kvm-amd" ];
      kernelParams = [ "amd_pstate=active" ];
    };
  };
}
