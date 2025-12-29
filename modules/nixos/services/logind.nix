{ lib, config, ... }:
let
  inherit (lib) mkIf mkMerge mkDefault;
  inherit (config.alchemy) system;
in {
  config = mkMerge [
    (mkIf (system.isServer) {
      services.logind.settings.Login = {
        KillUserProcesses = mkDefault true;
        HandlePowerKey = "ignore";
        HandlePowerKeyLongPress = "poweroff";
        SuspendKeyIgnoreInhibited = "yes";
        HibernateKeyIgnoreInhibited = "yes";
        LidSwitchIgnoreInhibited = "yes";
      };
      systemd.sleep.extraConfig = ''
        AllowSuspend=no
        AllowHibernation=no
        AllowSuspendThenHibernate=no
        AllowHybridSleep=no
      '';
    })
    (mkIf (system.isLaptop) {
      services.logind.settings.Login = {
        SleepOperation = "suspend";
        IdleAction = "lock";
        IdleActionSec = "20m";
        KillUserProcesses = false;
        HandlePowerKey = "suspend";
        HandleLidSwitch = "suspend";
        HandlePowerKeyLongPress = "poweroff";
        HibernateKeyIgnoreInhibited = "yes";
      };
      
    })
    (mkIf (system.isDesktop) {
      services.logind.settings.Login = {
        IdleAction = "lock";
        IdleActionSec = "40m";
        KillUserProcesses = false;
        HandlePowerKey = "suspend";
        HandlePowerKeyLongPress = "poweroff";
      };
    })
  ];
}
