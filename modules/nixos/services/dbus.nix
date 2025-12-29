{ lib, pkgs, config, ...}:
let
  inherit (lib) mkIf;
  inherit (config.alchemy) system;
in {
  config = mkIf (system.isGraphical) {
    users.groups.netdev = {};
    services.dbus = {
      enable = true;
      # Use the faster dbus-broker instead of the classic dbus-daemon
      implementation = "broker";
      packages = with pkgs; [
        dconf
        gcr_4
        gnome-keyring
        udisks
      ];
    };
    services.udisks2.enable = true;
    services.gvfs.enable = true;
    programs.dconf.enable = true;
    programs.seahorse.enable = true;
  };
}
