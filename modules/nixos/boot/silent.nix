{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.alchemy.boot;
in {
  options.alchemy.boot = {
    silentBoot = mkEnableOption "Almost entirely silent boot process through `quiet` kernel parameter";
  };
  
  config = mkIf cfg.silentBoot {
    boot.kernelParams = [
      "quiet"
      "loglevel=3"
      "udev.log_level=3"
      "rd.udev.log_level=3"
      "systemd.show_status=auto"
      "rd.systemd.show_status=auto"
      "vt.global_cursor_default=0"
    ];
  };
}
