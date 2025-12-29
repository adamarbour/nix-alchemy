{ pkgs, ... }:
{
  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  
  alchemy.secrets.enable = true;
  
  alchemy.system.virtualization = {
    incus.enable = true;
  };
  
  alchemy.system = {
    profiles = [ "laptop" "workstation" ];
    hardware = {
      cpu = "amd";
      gpu = "amd";
    };
    switch.bluetooth = true;
    switch.fprint = false;
    switch.printing = true;
    switch.thunderbolt = true;
    switch.tpm = true;
    switch.trackpoint = true;
  };
  
  alchemy.boot = {
    kernel = pkgs.linuxPackages_latest;
    loader = "lanzaboote";
    silentBoot = true;
    kernelModules = [ "thinkpad_acpi" ];
    blacklistedKernelModules = [ "sp5100_tco" ];
    kernelParams = [
      "amd_prefcore=enable"
      "preempt=full"
      "mem_sleep_default=s2idle"
      "nvme_core.default_ps_max_latency_us=3000"
      "amd_iommu=on"
      "iommu=pt"
    ];
  };
  
  alchemy.network = {
    wireless.backend = "wpa_supplicant";
    switch.tailscale = true;
  };
}
