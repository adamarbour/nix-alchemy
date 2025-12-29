{ lib, config, ... }:
let
  inherit (lib) optionals types mkIf mkOption;
  inherit (config.alchemy) system;
  inherit (config.services) tailscale;
  cfg = config.alchemy.network.switch;
in {
  options.alchemy.network.switch.tailscale = mkOption {
    type = types.bool;
    default = false;
    description = "enable tailscale networking support";
  };
  
  config = mkIf cfg.tailscale {
    services.tailscale = {
      enable = true;
      useRoutingFeatures = if (system.isServer) then "server" else "client";
      permitCertUid = "root";
      extraUpFlags = [ "--ssh" "--accept-routes" ] ++ optionals (system.isServer) [ "--advertise-exit-node" ];
      extraSetFlags = [ "--accept-dns" "--accept-routes" "--auto-update=false" "--exit-node-allow-lan-access" ];
      extraDaemonFlags = [ "--no-logs-no-support" ];
      
    };
    networking.firewall = {
      trustedInterfaces = [ "${tailscale.interfaceName}" ];
      allowedUDPPorts = [ tailscale.port ];
    };
  };
}
