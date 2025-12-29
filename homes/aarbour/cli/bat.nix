{ config, ... }:
let
  inherit (config.alchemy.programs) defaults;
  inherit (config.alchemy) system;
in {
  programs.bat = {
    enable = (system.isWorkstation);
    config = {
      inherit (defaults) pager;
    };
  };
}
