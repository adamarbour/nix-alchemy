{ lib, pkgs, config, ...}:
let
  inherit (lib) types mkIf mkDefault mkOption;
  cfg = config.alchemy.system.switch;
in {
  options.alchemy.system.switch.bluetooth = mkOption {
    type = types.bool;
    default = false;
    description = "enable bluetooth support";
  };
  
  config = mkIf cfg.bluetooth {
    boot.kernelModules = [ "btusb" ];
    services.blueman.enable = true;
    hardware.bluetooth = {
      enable = true;
      disabledPlugins = [ "sap" ];
      settings = {
        General = {
          ControllerMode = "dual";
          FastConnectable = true;
          JustWorksRepairing = "always";
          MultiProfile = "multiple";
          Privacy = "device";
          PairableTimeout = 30;
          DiscoverableTimeout = 30;
          TemporaryTimeout = 0;
        };
        Policy = {
          ReconnectIntervals = "1,1,2,3,5,8,13,21,34,55";
          AutoEnable = true;
          Privacy = "network/on";
        };
        LE = {
          MinConnectionInterval = "7";
          MaxConnectionInterval = "9";
          ConnectionLatency = "0";
        };
      };
    };
  };
}
