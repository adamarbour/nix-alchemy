{ lib, pkgs, config, ...}:
let
  inherit (lib) mkIf mkDefault mkForce;
  inherit (config.alchemy) system;
in {
  config = mkIf (system.isLaptop) {
    boot.kernel.sysctl = {
      	"vm.dirty_writeback_centisecs" = 6000;
      	"vm.laptop_mode" = 5;
    };
  };
}
