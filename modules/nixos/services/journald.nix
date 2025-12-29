{ lib, pkgs, config, ...}:
let
  inherit (lib) mkIf;
  inherit (config.alchemy) system;
in {
  config = mkIf (!system.isServer) {
    services.journald = {
      extraConfig = ''
          SystemMaxUse=100M
          RuntimeMaxUse=50M
          SystemMaxFileSize=128M
          RuntimeMaxFileSize=64M
          MaxRetentionSec=2weeks
          RateLimitIntervalSec=30s
          RateLimitBurst=1000
          Compress=yes
          Seal=yes
          ForwardToSyslog=no
          ForwardToConsole=no
          ForwardToWall=no
          SyncIntervalSec=5m
        '';
    };
  };
}
