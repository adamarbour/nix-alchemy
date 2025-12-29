{ lib, pkgs, config, ...}:
let
  inherit (lib) optionals mkIf;
  inherit (config.alchemy) system;
  cfg = config.alchemy.network;
in {
  environment.systemPackages = optionals (system.isGraphical) [ pkgs.networkmanagerapplet ];
  
  networking.networkmanager = mkIf (!system.isServer) {
    enable = true;
    plugins = optionals (system.isWorkstation) [
      pkgs.networkmanager-openvpn
      pkgs.networkmanager-openconnect
    ];
    dns = "systemd-resolved";
    unmanaged = [
      "interface-name:tailscale*"
      "interface-name:br-*"
      "interface-name:incusbr*"
      "interface-name:rndis*"
      "interface-name:docker*"
      "interface-name:virbr*"
      "interface-name:vboxnet*"
      "interface-name:waydroid*"
      "type:bridge"
    ];
    wifi = mkIf (cfg.wireless.backend != "none") {
      backend = cfg.wireless.backend;
      powersave = true;
      # MAC address randomization of a Wi-Fi device during scanning
      scanRandMacAddress = true;
    };
  };
}
