{ lib, pkgs, config, ... }:
let
  inherit (lib) mkIf mkMerge mkForce mkDefault;
  inherit (config.alchemy) system;
in {
  config = mkIf (system.isServer) {
    services.fail2ban = {
      enable = true;
      maxretry = 5;
      bantime = "1h";
      ignoreIP = [
        "127.0.0.0/8"
        "10.0.0.0/8"
        "192.168.0.0/16"
        "172.31.0.0/16"
      ];
      jails = mkMerge [
        {
          sshd = mkForce ''
            enabled = true
            port = ${lib.concatStringsSep "," (map toString config.services.openssh.ports)}
          '';
        }
      ];
      bantime-increment = {
        enable = true;
        rndtime = "7m";
        factor = "2";
        maxtime = "7d";
        overalljails = true; # Calculate the bantime based on all the violations
      };
    };
  };
}
