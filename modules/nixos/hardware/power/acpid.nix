{ lib, pkgs, config, ...}:
let
  inherit (lib) mkIf mkDefault mkForce;
  inherit (config.alchemy) system;
in {
  config = mkIf (system.isLaptop) {
    # handle ACPI events
    services.acpid.enable = true;
    
    environment.systemPackages = [
      pkgs.acpi
      pkgs.powertop
    ];
    
    boot = {
      kernelModules = [ "acpi_call" ];
      extraModulePackages = with config.boot.kernelPackages; [
        acpi_call
        cpupower
      ];
    };
  };
}
