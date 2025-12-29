{ lib, config, ...}:
let
  inherit (lib) mkIf;
  inherit (config.alchemy) system;
in {
  config = mkIf (system.isServer) {
    services.smartd.enable = (!system.isContainer);
  };
}
