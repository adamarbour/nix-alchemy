{ lib, pkgs, config, ... }:
let
  inherit (lib) types splitString genAttrs flip pipe elemAt mkIf mkEnableOption mkOption;
  getArch = flip pipe [
    (splitString "-")
    (flip elemAt 0)
  ];
  cfg = config.alchemy.nix;
in {
  options.alchemy.nix = {
    emulation = mkEnableOption "Enable per-host cross-build support (binfmt + extra platforms)";
    emulatedSystems = mkOption {
      type = types.listOf types.str;
      default = [];
      example = [ "aarch64-linux" "arm7l-linux" ];
      description = ''
        Values for boot.binfmt.emulatedSystems. Enables QEMU user binfmt so this host
        can *run/build* foreign-arch derivations locally.
      '';
    };
  };
  
  config = mkIf cfg.emulation {
    nix.settings.extra-sandbox-paths = [
      "/run/binfmt"
      (toString pkgs.qemu)
    ];
    
    boot.binfmt = {
      emulatedSystems = cfg.emulatedSystems;
      # emulated architectures
      registrations = genAttrs cfg.emulatedSystems (system: {
        interpreter = "${pkgs.qemu}/bin/qemu-${getArch system}";
      });
    };
  };
}
