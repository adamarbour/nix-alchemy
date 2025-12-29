{ lib, pkgs, config, ...}:
let
  inherit (lib) types attrValues mkIf mkDefault mkOption;
  cfg = config.alchemy.system.switch;
  printing = config.alchemy.printing;
in {
  options.alchemy.system.switch.printing = mkOption {
    type = types.bool;
    default = false;
    description = "enable printing support";
  };
  options.alchemy.printing.extraDrivers = mkOption {
    type = types.attrsOf types.path;
    default = { };
    description = "A list of additional drivers to install for printing";
  };
  
  config = mkIf cfg.printing {
    # enable cups and some drivers for common printers
    services = {
      printing = {
        enable = true;
        webInterface = config.services.printing.enable;
        browsing = mkDefault true;
        allowFrom = [ "localhost" ];
        drivers = attrValues (
          {
            inherit (pkgs) gutenprint cnijfilter2;
          } // printing.extraDrivers
        );
      };
      # required for network discovery of printers
      avahi = {
        enable = true;
        nssmdns4 = true;
        nssmdns6 = true;
        openFirewall = true;
      };
    };
  };
}
