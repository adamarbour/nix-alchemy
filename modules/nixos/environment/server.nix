{ lib, pkgs, config, ...}:
let
  inherit (lib) mkIf mkDefault mkForce;
  inherit (config.alchemy) system;
in {
  config = mkIf (system.isServer) {
    programs.git.package = mkDefault pkgs.gitMinimal;
    environment.variables.BROWSER = "echo";
    fonts.fontDir.enable = mkDefault false;
    fonts.fontconfig.enable = mkDefault false;
    
    systemd = {
      # Prefer to continue booting in all scenarios
      enableEmergencyMode = false;
      
      # For more detail, see:
      #   https://0pointer.de/blog/projects/watchdog.html
      settings.Manager = {
        # systemd will send a signal to the hardware watchdog at half
        # the interval defined here, so every 10s.
        # If the hardware watchdog does not get a signal for 20s,
        # it will forcefully reboot the system.
        RuntimeWatchdogSec = "20s";
        # Forcefully reboot if the final stage of the reboot
        # hangs without progress for more than 30s.
        # For more info, see:
        #   https://utcc.utoronto.ca/~cks/space/blog/linux/SystemdShutdownWatchdog
        RebootWatchdogSec = "30s";
      };

      sleep.extraConfig = ''
        AllowSuspend=no
        AllowHibernation=no
      '';
    };
    
    # freedesktop xdg files
    xdg.autostart.enable = mkDefault false;
    xdg.icons.enable = mkDefault false;
    xdg.menus.enable = mkDefault false;
    xdg.mime.enable = mkDefault false;
    xdg.sounds.enable = mkDefault false;
    
    services.udisks2.enable = mkForce false;
    
    # UTC everywhere!
    time.timeZone = mkForce "UTC";
  };
}
