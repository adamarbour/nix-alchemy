{ lib, pkgs, config, ... }:
let
  inherit (lib) mkIf mkDefault;
  inherit (config.alchemy) system;
in {
  config = mkIf (system.isGraphical) {
    programs.zed-editor = {
      enable = true;
    };
  };
}
