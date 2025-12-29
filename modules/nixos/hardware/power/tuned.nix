{ lib, pkgs, config, ...}:
let
  inherit (lib) mkIf mkDefault mkForce;
  inherit (config.alchemy) system;
in {
  config = mkIf (system.isLaptop) {
    services = {
      tuned = {
        enable = true;
        settings.dynamic_tuning = true;
        ppdSettings = {
          # Automatic change profile based on battery charging state
          main.battery_detection = true;
          # Map TuneD to power-profiles-daemon profiles
          battery = {
            balanced = "balanced-battery";
            performance = "balanced";
            power-saver = "powersave";
          };
          profiles = {
            balanced = "balanced";
            performance = "throughput-performance";
            power-saver = "powersave";
          };
        };
      };
    };
  };
}
