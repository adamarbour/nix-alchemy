{
  disko.devices.disk.disk0 = {
    type = "disk";
    device = "/dev/disk/by-id/nvme-Samsung_SSD_980_PRO_1TB_S5P2NL0WC03960J";
    content = {
      type = "gpt";
      partitions = {
        boot = {
          size = "1M";
          type = "EF02"; # for grub MBR
          priority = 100;
        };
        esp = {
          name = "ESP";
          size = "512M";
          type = "EF00";
          priority = 1000;
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = [ "umask=0077" ];
          };
        };
        rootfs = {
          end = "-10M";
          content = {
            type = "btrfs";
            extraArgs = [ "-f" "-L BTRFS" ];
            mountOptions = [ "compress=zstd" "noatime" ];
            postCreateHook = ''
                MNTPOINT=$(mktemp -d)
                mount -L BTRFS "$MNTPOINT" -o subvol=/
                trap 'umount $MNTPOINT; rm -rf $MNTPOINT' EXIT
                btrfs subvolume snapshot -r $MNTPOINT/rootfs $MNTPOINT/rootfs-blank
              '';
            subvolumes = {
              "/rootfs" = {
                mountpoint = "/";
              };
              "/home" = {
                mountpoint = "/home";
              };
              "/nix" = {
                mountpoint = "/nix";
                mountOptions = [ "compress-force=zstd:3" ];
              };
              "/tmp" = {
                mountpoint = "/tmp";
              };
              "/snapshots" = {
                mountpoint = "/.snapshots";
              };
              "/persist" = {
                mountpoint = "/.persist";
                mountOptions = [ "lazytime" ];
              };
            };
          };
        };
      };
    };
  };
}
