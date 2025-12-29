{ lib, pkgs, config, ...}:
let
  inherit (lib) mkIf genAttrs mkForce;
  inherit (config.alchemy) system;
in {
  config = mkIf (system.isGraphical) {
    environment.systemPackages = with pkgs; [
      gnome-keyring libsecret
    ];
    
    services = {
      udev.packages = [ pkgs.gnome-settings-daemon ];
      gnome = {
        glib-networking.enable = true;
        gnome-keyring.enable = true;
        gcr-ssh-agent.enable = false;
        gnome-remote-desktop.enable = mkForce false;
      };
    };
  };
}
