{ lib, pkgs, config, ...}:
let
  inherit (lib) mkIf mkDefault mkForce;
  inherit (config.alchemy) system;
in {
  config = mkIf (system.isLaptop) {
    services = {
      thermald.enable = config.alchemy.system.hardware.cpu == "intel";
      power-profiles-daemon.enable = mkForce false;
      tlp.enable = mkForce false;
      auto-cpufreq.enable = mkForce false;
    };
    powerManagement = {
      enable = true;
      cpuFreqGovernor = "powersave";
      powertop.enable = true;
    };
    systemd.tmpfiles.rules = [
      "f /sys/class/rtc/rtc0/wakealarm 0664 root root -"
    ];
  };
}
