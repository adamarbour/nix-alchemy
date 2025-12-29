{ lib, config, ...}:
let
  inherit (lib) mkIf mkDefault;
in {
  config = {
    boot = {
      consoleLogLevel = 3;
      loader.efi.canTouchEfiVariables = true;
      
      # whether to enable support for Linux MD RAID arrays
      # as of 23.11>, this throws a warning if neither MAILADDR nor PROGRAM are set
      swraid.enable = mkDefault false;
      
      # increase the map count, this is important for applications that require a lot of memory mappings
      # such as games and emulators
      kernel.sysctl."vm.max_map_count" = 2147483642;
    };
    environment.systemPackages = [ config.boot.kernelPackages.cpupower ];
  };
}
