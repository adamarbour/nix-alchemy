{ lib, pkgs, config, ...}:
let
  inherit (lib) mkIf;
  inherit (config.alchemy) system;
in {
  config = mkIf (system.isServer || system.isWorkstation) {
    services.clamav = {
      daemon = {
        enable = true;
        settings = {
          DetectPUA = true;
          ExtendedDetectionInfo = true;
          FollowDirectorySymlinks = true;
          FollowFileSymlinks = true;
          LogFile = "/tmp/clamd.log";
          LogSyslog = true;
          LogTime = true;
          MaxDirectoryRecursion = 30;
          OnAccessExcludeUname = "clamav";
          OnAccessExtraScanning = true;
          OnAccessPrevention = true;
        };
      };
      
      scanner = {
        enable = true;
        scanDirectories = [
          "/etc"
          "/home"
          "/srv"
          "/tmp"
          "/var/lib"
          "/var/tmp"
        ];
      };
      
      updater = {
        enable = true;
        frequency = 24;
        interval = "hourly";
      };
    };
  };
}
