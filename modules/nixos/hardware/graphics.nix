{ lib, config, ...}:
let
  inherit (lib) mkIf;
  inherit (config.alchemy) system;
in {
  config = mkIf (system.isGraphical) {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}
