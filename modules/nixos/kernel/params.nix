{ lib, config, ... }:
let
  inherit (lib) types mkOption;
  cfg = config.alchemy.boot;
in {
  options.alchemy.boot = {
    kernelParams = mkOption {
      type = types.listOf types.str;
      default = [];
    };
  };
  
  config = {
    boot.kernelParams = [
      "nohz_full=4-7"
      "nmi_watchdog=0"
      "pti=auto"
      "fbcon=nodefer"
      "iommu=pt"
      "noresume"
      # Security
      "oops=panic"
      "randomize_kstack_offset=on"
      "module.sig_enforce=1"
      "page_poison=on"
      "page_alloc.shuffle=1"
      "mitigations=auto,nosmt"
    ] ++ cfg.kernelParams;
  };
}
