{ lib, pkgs, config, ...}:
let
  inherit (lib) mkIf getExe mkDefault;
  inherit (config.alchemy) system;
in {
  config = mkIf (system.isGraphical) {
    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
      config.common = {
        default = [ "gtk" ];
        "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
      };
      extraPortals = [ 
        pkgs.xdg-desktop-portal-gtk
      ];
      wlr = {
        enable = mkDefault true;
        settings = {
          screencast = {
            max_fps = 60;
            chooser_type = "simple";
            chooser_cmd = "${getExe pkgs.slurp} -f %o -or";
          };
        };
      };
    };
  };
}
