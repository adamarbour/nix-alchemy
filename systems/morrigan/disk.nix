{
  fileSystems."/" =
    { device = "/dev/disk/by-uuid/c7f3a359-bf5e-44f0-baad-cc354727af5e";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/36A3-C0A6";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  swapDevices = [ ];
}
