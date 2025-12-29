{ lib, config, ...}:
let
  inherit (lib) mkIf;
  inherit (config.alchemy) system;
in {
  config = mkIf (system.isGraphical) {
    services.pulseaudio.enable = !config.services.pipewire.enable;
  };
}
