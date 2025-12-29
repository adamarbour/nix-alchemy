{ pkgs, ... }:
{ 
  hardware = {
    brillo.enable = true;
    trackpoint.device = "TPPS/2 Elan TrackPoint";
    i2c.enable = true;
  };
  
  systemd.tmpfiles.rules = [ 
    "w /sys/power/image_size - - - - 0"
    "w /sys/devices/platform/smapi/BAT0/start_charge_thresh - - - - 40"
    "w /sys/devices/platform/smapi/BAT0/stop_charge_thresh - - - - 80"
  ];
}
