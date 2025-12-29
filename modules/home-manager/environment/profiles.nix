{ lib, osConfig, ... }:
let
  inherit (lib) mkOption types;
  inherit (lib.alchemy) hasProfile;
  inherit (osConfig.alchemy) system;
in {
  options.alchemy.system = {
    profiles = mkOption {
      type = types.listOf types.str;
      default = system.profiles;
      readOnly = true;
    };
    isDesktop = mkOption {
      type = types.bool;
      default = system.isDesktop;
      readOnly = true;
    };
    isLaptop = mkOption {
      type = types.bool;
      default = system.isLaptop;
      readOnly = true;
    };
    isWorkstation = mkOption {
      type = types.bool;
      default = system.isWorkstation;
      readOnly = true;
    };
    isServer = mkOption {
      type = types.bool;
      default = system.isServer;
      readOnly = true;
    };
    isContainer = mkOption {
      type = types.bool;
      default = system.isContainer;
      readOnly = true;
    };
    isGraphical = mkOption {
      type = types.bool;
      default = system.isGraphical;
      readOnly = true;
    };
    isHeadless = mkOption {
      type = types.bool;
      default = system.isHeadless;
      readOnly = true;
    };
  };
}
