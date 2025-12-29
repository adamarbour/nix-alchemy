{ lib, config, ...}:
let
  inherit (lib) mkIf mkDefault;
  inherit (config.alchemy) system;
in {
  security = {
    polkit.enable = true;
    soteria = mkIf (system.isGraphical) {
      enable = mkDefault true;
    };
  };
}
