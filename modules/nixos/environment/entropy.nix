{ lib, config, ... }:
let
  inherit (lib) mkIf;
in {
  config = mkIf (!config.boot.isContainer) {
    boot.kernelModules = [ "jitterentropy_rng" ];
    services.jitterentropy-rngd.enable = true;
  };
}
