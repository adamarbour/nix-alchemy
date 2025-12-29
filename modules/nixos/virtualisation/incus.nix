{ lib, config, ... }:
let
  inherit (lib) types mkIf mkDefault mkEnableOption mkOption;
  cfg = config.alchemy.system.virtualization.incus;
  
  preseedConfig = {
    networks = [{
      name = cfg.bridgeName;
      type = "bridge";
      config = {
        "dns.mode" = "managed";
        "ipv4.address" = "10.24.13.1/24";
        "ipv4.dhcp.ranges" = "10.24.13.101-10.24.13.251";
        "ipv4.nat" = "true";
        "ipv4.dhcp" = "true";
        # No need for ipv6 in bridge...
        "ipv6.address" = "none";
        "ipv6.nat" = "false";
      };
    }];
    profiles = [{
      name = "default";
      devices = {
        eth0 = {
          name = "eth0";
          network = cfg.bridgeName;
          type = "nic";
        };
      };
    }];
    storage_pools = [{
      name = "default";
      driver = "dir";
      config = {
        source = "/var/lib/incus/storage-pools/default";
      };
    }];
  };
in {
  options.alchemy.system.virtualization.incus = {
    enable = mkEnableOption "Incus with declarative preseed";
    bridgeName = mkOption {
      type = types.str;
      default = "incusbr0";
    };
  };
  
  config = mkIf cfg.enable {
    # Ensure nftables is enabled...
    networking.nftables.enable = mkDefault true;
    
    virtualisation.incus = {
      enable = true;
      preseed = preseedConfig;
    };
    
    networking.firewall.trustedInterfaces = [ cfg.bridgeName ];
  };
}
