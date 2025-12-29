{ lib, pkgs, config, ...}:
let
  inherit (lib) types mkIf mkOption;
  cfg = config.alchemy.system.switch;
in {
  options.alchemy.system.switch.tpm = mkOption {
    type = types.bool;
    default = false;
    description = "enable tpm support";
  };
  
  config = mkIf cfg.tpm {
    security.tpm2 = {
      enable = true;
      abrmd.enable = false;
      tctiEnvironment.enable = true;
      pkcs11.enable = true;
    };
    boot.initrd.kernelModules = [ "tpm" ];
  };
}
