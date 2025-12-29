{ lib, pkgs, config, ...}:
let
  inherit (lib) types genAttrs mkIf mkOption;
  cfg = config.alchemy.system.switch;
  
  pamServices = [ 
    "login" "sudo" "greetd" "hyprlock" "polkit-1" "swaylock"
  ];
in {
  options.alchemy.system.switch.fprint = mkOption {
    type = types.bool;
    default = false;
    description = "enable fingerprint reader support";
  };
  
  config = mkIf cfg.fprint {
    services.fprintd.enable = true;
    # Toggle fingerprint auth per selected PAM service
    security.pam.services = genAttrs pamServices (_: { fprintAuth = true; });
  };
}
