{ lib, config, ...}:
let
  inherit (lib) mkIf;
  inherit (config.alchemy) system;
in {
  services.seatd = mkIf (system.isGraphical) {
    enable = true;
  };
}
