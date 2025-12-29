{ lib, pkgs, config, ...}:
let
  inherit (lib) types mkIf mkOption;
  cfg = config.alchemy.system.switch;
in {
  options.alchemy.system.switch.thunderbolt = mkOption {
    type = types.bool;
    default = false;
    description = "enable thunderbolt docking support";
  };
  
  config = mkIf cfg.thunderbolt {
    services.hardware.bolt.enable = true;
    services.udev.packages = [ pkgs.bolt ];
    services.logind.settings.Login = {
      HandleLidSwitchDocked = "ignore";
    };
    boot = {
      initrd.availableKernelModules = [ "thunderbolt" ];
    };
  };
}
