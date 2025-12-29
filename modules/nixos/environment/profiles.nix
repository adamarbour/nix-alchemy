{ lib, config, ... }:
let
  inherit (lib) mkOption types;
  inherit (lib.alchemy) hasProfile;
  inherit (config.alchemy) system;
  profileList = [
    "server"
    "laptop"
    "desktop"
    "container"
    "gaming"
    "workstation"
  ];
  
  coreProfiles = [ "server" "laptop" "desktop" "container" ];
  coreSelected = builtins.filter (p: builtins.elem p coreProfiles) system.profiles;
  coreCount = builtins.length coreSelected;
in {
  options.alchemy.system = {
    profiles = mkOption {
      type = types.listOf (types.enum profileList);
      default = [];
      description = "List of profiles enabled for this host";
      example = [ "laptop" "workstation" ];
    };
    isDesktop = mkOption {
      type = types.bool;
      default = (hasProfile "desktop" system.profiles);
      readOnly = true;
    };
    isLaptop = mkOption {
      type = types.bool;
      default = (hasProfile "laptop" system.profiles);
      readOnly = true;
    };
    isWorkstation = mkOption {
      type = types.bool;
      default = (hasProfile "workstation" system.profiles);
      readOnly = true;
    };
    isServer = mkOption {
      type = types.bool;
      default = (hasProfile "server" system.profiles);
      readOnly = true;
    };
    isContainer = mkOption {
      type = types.bool;
      default = ((hasProfile "container" system.profiles) || (config.boot.isContainer));
      readOnly = true;
    };
    isGraphical = mkOption {
      type = types.bool;
      default = (system.isDesktop || system.isLaptop);
      readOnly = true;
    };
    isHeadless = mkOption {
      type = types.bool;
      default = (system.isServer || !system.isGraphical);
      readOnly = true;
    };
  };
  config = {
    assertions = [
      { assertion = coreCount == 1;
        message = ''
          alchemy.system.profiles must contain exactly one of: ${lib.concatStringsSep ", " coreProfiles}.
          Current: ${lib.concatStringsSep ", " system.profiles}
        '';
      }
    ];
  };
}
