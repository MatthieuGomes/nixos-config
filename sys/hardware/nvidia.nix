# TODO : FIX !!!
{
  config,
  lib,
  pkgs-list,
  parentPathAsList,
  tools,
  ...
}: let
  moduleParams = tools.moduleParams rec {
    inherit config lib pkgs-list parentPathAsList tools;
    name = "nvidia";
    options = {
      enable = lib.mkEnableOption "Enables and configures ${name} hardware support.";
    };
  };
in (tools.fullModule {
  inherit (moduleParams) config lib pkgs-list parentPathAsList tools;
  inherit (moduleParams) name togglable subfolder main-repo branch extras imports specialImports options settings;
  inherit (moduleParams) packages currentPathAsList currentDirPath cfg inheritedSettings Common;
  System = {
    hardware = {
      graphics = {
        enable32Bit = true;
        enable = true;
      };
      nvidia = {
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
})
