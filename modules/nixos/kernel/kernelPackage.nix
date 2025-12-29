{ lib, pkgs, config, sources, ... }:
let
  inherit (lib) types mkOption mkOverride mapAttrsToList;
  inherit (lib.alchemy) isServer isGraphical;
  profiles = config.alchemy.system.profiles;
  cfg = config.alchemy.boot;
  
  defaultKernel = if (isGraphical profiles) then pkgs.linuxPackages_zen
    else if (isServer profiles) then pkgs.linuxPackages_hardened
    else pkgs.linuxPackages_latest;
    
in {
  options.alchemy.boot = {
    kernel = mkOption {
      type = types.raw;
      default = defaultKernel;
      defaultText = "${defaultKernel}";
      description = "The kernel to use for the system.";
    };
  };
  
  config = {
    boot = {
      kernelPackages = mkOverride 500 cfg.kernel;
    };
  };
}
