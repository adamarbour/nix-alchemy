{ lib, pkgs, config, sources, ... }:
let
  inherit (lib) types mkMerge mkIf mkOption mkEnableOption mkPackageOption mkForce mkDefault;
  lanzaboote = import sources.lanzaboote { inherit pkgs; };
  cfg = config.alchemy.boot;
in {
  imports = [ lanzaboote.nixosModules.lanzaboote ];
  
  options.alchemy.boot = {
    loader = mkOption {
      type = types.enum [
        "none"
        "grub"
        "systemd"
        "lanzaboote"
      ];
      default = "none";
      description = "The bootloader that should be used for the device.";
    };
    grub = {
      device = mkOption {
        type = types.nullOr types.str;
        default = "nodev";
        description = "The device to install the bootloader to.";
      };
    };
  };
  
  config = mkMerge [
    (mkIf (cfg.loader == "none") {
      boot.loader = {
        grub.enable = mkForce false;
        systemd-boot.enable = mkForce false;
      };
    })
    
    (mkIf (cfg.loader == "grub") {
      boot.loader.grub = {
        enable = mkDefault true;
        useOSProber = mkDefault false;
        efiSupport = true;
        enableCryptodisk = mkDefault false;
        inherit (cfg.grub) device;
        theme = null;
        backgroundColor = null;
        splashImage = null;
      };
    })
    
    (mkIf (cfg.loader == "systemd") {
      boot.loader.systemd-boot = {
        enable = mkDefault true;
        consoleMode = mkDefault "max"; # the default is "keep"
        editor = false;
      };
    })
    
    (mkIf (cfg.loader == "lanzaboote") {
      environment.systemPackages = [
        pkgs.sbctl
      ];
      boot = {
        loader.grub.enable = mkForce false;
        loader.systemd-boot.enable = mkForce false;
        lanzaboote = {
          enable = true;
          autoGenerateKeys.enable = true;
          autoEnrollKeys.enable = true;
          pkiBundle = "/var/lib/sbctl";
        };
      };
    })
  ];
}
