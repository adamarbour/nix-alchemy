{ lib, config, ... }:
let
  inherit (lib) mkDefault mkForce;
in {
  networking.resolvconf.enable = !(config.services.resolved.enable);
  services.resolved = {
    enable = mkDefault true;
    dnsovertls = "opportunistic";
    dnssec = "true";
    llmnr = "resolve";
  };
}
