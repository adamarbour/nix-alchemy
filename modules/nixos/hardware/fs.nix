{ lib, pkgs, config, ...}:
let
  inherit (lib) mkMerge mkIf filterAttrs;
  hasBtrfs = (lib.filterAttrs (_: v: v.fsType == "btrfs") config.fileSystems) != { };
  hasZfs = (lib.filterAttrs (_: v: v.fsType == "zfs") config.fileSystems) != { };
in {
  config = mkMerge [
    {
      services.fstrim = {
        enable = true;
        interval = "weekly";
      };
    }
    
    # clean btrfs devices
    (mkIf hasBtrfs {
      services.btrfs.autoScrub = {
        enable = true;
        interval = "monthly";
      };
    })
    
    # clean zfs devices
    (mkIf hasZfs {
      services.zfs = {
        trim = {
          enable = true;
          interval = "weekly";
        };
        autoScrub = {
          enable = true;
          interval = "monthly";
        };
      };
    })
  ];
}
