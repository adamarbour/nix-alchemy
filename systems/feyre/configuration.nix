{ pkgs, ... }:
{
  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  
  alchemy.secrets.enable = true;
  
  alchemy.system = {
    profiles = [ "laptop" "workstation" ];
    hardware = {
      cpu = "intel";
      gpu = "intel";
    };
    switch.tpm = true;
  };
  
  alchemy.boot = {
    kernel = pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto;
    loader = "systemd";
    silentBoot = true;
  };
  
  alchemy.network = {
    wireless.backend = "iwd";
    switch.tailscale = true;
  };
}
