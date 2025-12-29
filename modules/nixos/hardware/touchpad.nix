{ lib, pkgs, config, ...}:
let
  inherit (lib) types mkIf mkDefault mkOption;
  inherit (config.alchemy) system;
  cfg = config.alchemy.system.switch;
in {
  options.alchemy.system.switch.trackpoint = mkOption {
    type = types.bool;
    default = false;
    description = "enable trackpoint support";
  };
  
  config = mkIf (system.isLaptop) {
    services.libinput = {
      enable = true;
      
      # disable mouse acceleration
      mouse = {
        accelProfile = "flat";
        accelSpeed = "0";
        middleEmulation = false;
      };
      
      # touchpad settings
      touchpad = {
        naturalScrolling = true;
        tapping = true;
        clickMethod = "clickfinger";
        disableWhileTyping = true;
      };
    };
    hardware.trackpoint = mkIf cfg.trackpoint {
      enable = true;
      emulateWheel = mkDefault config.hardware.trackpoint.enable;
    };
  };
}
