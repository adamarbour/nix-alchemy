{ lib, config, ...}:
let
  inherit (lib) types mkEnableOption mkOption mkIf;
  inherit (config.alchemy) system;
  cfg = config.alchemy.system.hardware;
  gpu = config.alchemy.system.hardware.gpu;
in {
  options.alchemy.system.hardware.prime = {
    enable = mkEnableOption "NVIDIA dGPU as secondary (Optimus/PRIME)";
    nvidiaBusId = mkOption {
      type = types.str;
      description = "NVIDIA dGPU Bus ID (PCI:B:D:F).";
    };
    iGpuBusId = mkOption {
      type = types.str;
      description = "iGpu Bus ID (PCI:B:D:F).";
    };
    mode = mkOption {
      type = types.enum [ "offload" "sync" ];
      default = "offload";
      description = ''
        PRIME mode:
          - offload: iGPU renders by default; run apps on dGPU explicitly.
          - sync: dGPU renders everything; higher power usage.
      '';
    };
    dynamicBoost = mkOption {
      type = types.bool;
      default = (system.isLaptop);
      description = "enable dynamic Boost balances power between the CPU and the GPU.";
    };
    finegrainedPM = mkOption {
      type = types.bool;
      default = (system.isLaptop);
      description = "enable experimental power management of PRIME offload.";
    };
  };
  
  config = mkIf (cfg.prime.enable) {
    boot.blacklistedKernelModules = [ "nouveau" ];
    services.xserver.videoDrivers = [ "nvidia" ];
    
    hardware.nvidia = {
      modesetting.enable = true;
      package = config.boot.kernelPackages.nvidiaPackages.beta;
      
      prime = {
        nvidiaBusId = cfg.prime.nvidiaBusId;
        intelBusId = mkIf (gpu == "intel") cfg.prime.iGpuBusId;
        amdgpuBusId = mkIf (gpu == "amd") cfg.prime.iGpuBusId;
        
        offload.enable = cfg.prime.mode == "offload";
        offload.enableOffloadCmd = cfg.prime.mode == "offload";
        sync.enable = cfg.prime.mode == "sync";
      };
      
      dynamicBoost.enable = cfg.prime.dynamicBoost;
      powerManagement = {
        enable = true;
        finegrained = cfg.prime.finegrainedPM;
      };
      # dont use the open drivers by default
      open = false;
      # adds nvidia-settings to pkgs, so useless on nixos
      nvidiaSettings = false;
      nvidiaPersistenced = true;
      videoAcceleration = true;
      forceFullCompositionPipeline = false;
    };
  };
}
