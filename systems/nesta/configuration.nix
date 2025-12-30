{ pkgs, ... }:
{
  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  
  alchemy.secrets.enable = true;
  
  alchemy.system = {
    profiles = [ "desktop" "workstation" ];
    hardware = {
      cpu = "amd";
      gpu = "amd";
    };
    switch.tpm = true;
  };
  
  alchemy.boot = {
    kernel = pkgs.cachyosKernels.linuxPackages-cachyos-bore-lto;
    loader = "systemd";
    silentBoot = true;
  };
  
  alchemy.network = {
    wireless.backend = "iwd";
    switch.tailscale = true;
  };
}
