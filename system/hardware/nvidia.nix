{
  config,
  lib,
  inputs,
  ...
} @ Inputs: let
in {
  options = {
    nvidia.enable = lib.mkEnableOption "Enable NVIDIA proprietary driver support.";
  };
  imports = [];
  config = lib.mkIf config.nvidia.enable {
    hardware = {
      graphics = {
        enable32Bit = true;
        enable = true;
      };
      nvidia = {
        package = config.boot.kernelPackages.nvidiaPackages.production;
        open = true;
        modesetting.enable = true;
        nvidiaSettings = true;
        prime = {
          intelBusId = "PCI:0@0:2:0";
          nvidiaBusId = "PCI:0@1:0:0";
          offload = {
            enable = true;
            enableOffloadCmd = true;
          };
          sync.enable = false;
          reverseSync.enable = false;
          # allowExternalGpus = false;
        };
      };
    };
    services.xserver.videoDrivers = [
      "nvidia"
      "modesetting"
    ];
  };
}
