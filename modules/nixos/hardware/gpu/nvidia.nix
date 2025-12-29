{ lib, pkgs, config, ... }:
let
  inherit (lib) mkIf;
  cfg = config.alchemy.system.hardware;
in {
  config = mkIf (cfg.gpu == "nvidia") {
    services.xserver.videoDrivers = [ "nvidia" ];
    
    hardware = {
      nvidia = {
        # use the latest and greatest nvidia drivers
        package = config.boot.kernelPackages.nvidiaPackages.beta;
        powerManagement = {
          enable = true;
          finegrained = false;
        };
        # dont use the open drivers by default
        open = false;
        # adds nvidia-settings to pkgs, so useless on nixos
        nvidiaSettings = false;
        nvidiaPersistenced = true;
      };
      graphics = {
        extraPackages = [ pkgs.nvidia-vaapi-driver ];
        extraPackages32 = [ pkgs.pkgsi686Linux.nvidia-vaapi-driver ];
      };
    };
  
    # Enables the Nvidia's experimental framebuffer device
    # fix for the imaginary monitor that does not exist
    boot.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
    boot.kernelParams = [ "nvidia_drm.fbdev=1" "nvidia_drm.modeset=1" ];
    boot.blacklistedKernelModules = [ "nouveau" ];
    
    environment.sessionVariables = {
      LIBVA_DRIVER_NAME = "nvidia";
    };
    
    environment.systemPackages = with pkgs; [
      # vulkan
      vulkan-tools
      vulkan-loader
      vulkan-validation-layers
      vulkan-extension-layer
      # libva
      libva
      libva-utils
    ];
  };
}
