{ lib, pkgs, config, ...}:
let
  inherit (lib) mkIf;
  inherit (lib.alchemy) hasProfile;
  profiles = config.alchemy.system.profiles;
in {
  config = mkIf (hasProfile "gaming" profiles) {
    hardware = {
      uinput.enable = true;
      steam-hardware.enable = true;
      xpadneo.enable = true;
    };
    services.udev.packages = with pkgs; [
      steam-devices-udev-rules
      game-devices-udev-rules
    ];
  };
}
