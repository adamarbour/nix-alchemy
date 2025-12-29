{ lib, config, ...}:
let
  inherit (lib) mkIf;
  inherit (config.alchemy) system;
in {
  config = mkIf (system.isGraphical) {
    location.provider = "geoclue2";
    services.geoclue2 = {
      # enable geoclue2 only if location.provider is geoclue2
      enable = config.location.provider == "geoclue2";

      appConfig.gammastep = {
        isAllowed = true;
        isSystem = false;
      };
    };
  };
}
