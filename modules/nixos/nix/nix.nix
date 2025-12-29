{ lib, config, sources, ... }:
let
  inherit (lib) mkDefault;
in {
  nix = {
    channel.enable = false;
    optimise = {
      automatic = mkDefault (!config.boot.isContainer);
      dates = [ "04:00" ];
    };
    
    registry.nixpkgs.to = {
      type = "path";
      path = sources.nixpkgs;
    };
    
    gc = {
      automatic = true;
      dates = "Mon *-*-* 03:00";
      options = "--delete-older-than 5d";
    };
    
    daemonCPUSchedPolicy = mkDefault "batch";
    daemonIOSchedClass = mkDefault "idle";
    daemonIOSchedPriority = mkDefault 7;
  };
  
  systemd.services.nix-gc.serviceConfig = {
    CPUSchedulingPolicy = "batch";
    IOSchedulingClass = "idle";
    IOSchedulingPriority = 7;
  };
  
  systemd.services.nix-daemon = {
    environment = {
      TMPDIR = "/var/cache/nix";
    };
    serviceConfig = {
      CacheDirectory = "nix";
    };
  };
}
