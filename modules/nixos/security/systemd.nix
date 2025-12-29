{ lib, config, ... }:
let
  inherit (lib) mkDefault;
  inherit (config.alchemy) system;
in {
  config = {
    # Add "proc" group to whitelist /proc access and allow systemd-logind to view
    # /proc in order to unbreak it, as well as to user@ for similar reasons.
    # See https://github.com/systemd/systemd/issues/12955, and https://github.com/Kicksecure/security-misc/issues/208
    users.groups.proc.gid = config.ids.gids.proc;
    systemd.services.systemd-logind.serviceConfig.SupplementaryGroups = [ "proc" ];
    systemd.services."user@".serviceConfig.SupplementaryGroups = [ "proc" ];
    
    # Don't store coredumps from systemd-coredump.
    systemd.coredump.extraConfig = ''
      Storage=none
    '';
    
    # Enable IPv6 privacy extensions for systemd-networkd.
    systemd.network.config.networkConfig.IPv6PrivacyExtensions = mkDefault "kernel";
    
    # Ensure nixos is owned by root and homes are owned by the respective users.
    systemd.tmpfiles.rules = [
      "d /etc/nixos 0700 root root -"
      "Z /etc/nixos 0600 root root -"
    ] ++ (map (u: "z /home/${u} 0700 ${u} users -") system.users);
  };
}
