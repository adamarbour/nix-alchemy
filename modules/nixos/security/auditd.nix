{ lib, pkgs, config, ...}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (config.alchemy) system;
  cfg = config.alchemy.security.auditd;
in {
  options.alchemy.security.auditd = {
    enable = mkEnableOption "Enable the audit daemon" // {
      default = system.isServer;
    };
  };
  config = mkIf cfg.enable {
    # start as early in the boot process as possible
    boot.kernelParams = ["audit=1"];
    
    security = {
      auditd.enable = true;
      audit = {
        enable = true;
        backlogLimit = 8192;
        failureMode = "printk";
        rules = [
          "-w /etc/passwd -p wa -k passwd_changes"
          "-w /etc/shadow -p wa -k shadow_changes"
          "-a always,exit -F arch=b64 -S execve -k exec_log"
        ];
      };
    };
    
    # the audit log can grow quite large, so we _can_ automatically prune it
    systemd = {
      timers."clean-audit-log" = {
        description = "Periodically clean audit log";
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnCalendar = "weekly";
          Persistent = true;
        };
      };

      services."clean-audit-log" = {
        script = ''
          set -eu
          if [[ $(stat -c "%s" /var/log/audit/audit.log) -gt 524288000 ]]; then
            echo "Clearing Audit Log";
            rm -rvf /var/log/audit/audit.log;
            echo "Done!"
          fi
        '';

        serviceConfig = {
          Type = "oneshot";
          User = "root";
        };
      };
    };
  };
}
