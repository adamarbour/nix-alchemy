{ lib, pkgs, config, ... }:
let
  inherit (lib) mkIf mkDefault;
  inherit (config.alchemy) system;
in {
  config = mkIf (system.isGraphical) {
    programs.firefox = {
      enable = true; # TODO: Handle with defaults
      package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
        extraPolicies = {
          DisableFirefoxStudies = true;
          DisablePocket = true;
          DisableTelemetry = true;
          DisableFirefoxAccounts = true;
        };
      };
      
      profiles.default = {
        id = 0;
        name = "ff-alchemy-default";
        search.force = true;
        search.engines = {
          bing.metaData.hidden = true;
          amazondotcom-us.metaData.hidden = true;
          wikipedia.metaData.hidden = true;
          google.metaData.alias = "@g";
        };
      };
    };
  };
}
