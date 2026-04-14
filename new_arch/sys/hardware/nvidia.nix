# TODO : FIX !!!
{
  config,
  lib,
  pkgs-list,
  oldPathNames,
  tools,
  ...
} @ Inputs: let
  name = "nvidia";
  main-repo = "nix";
  branch = "latest";
  packages = pkgs-list.${main-repo}.${branch};
  pathNames = oldPathNames ++ [name];
  fullPath = lib.concatStringsSep "." pathNames;
  cfg = config.sys.hardware.${name};
  options.sys.hardware.${name} = {
    enable = lib.mkEnableOption "Enables and configures ${name} hardware support.";
  };
  Common = {
  };
  Home = {
  };
  System = {
    hardware = {
      graphics = {
        enable32Bit = true;
        enable = true;
      };
      nvidia = {
        package = config.boot.kernelPackages.nvidiaPackages.latest;
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
  HomeConfig = Common // Home;
  SystemConfig = Common // System;
in {
  config = {
    Home = {
      lib,
      config,
      ...
    }: {
      inherit options;
      config = lib.mkIf cfg.enable HomeConfig;
    };
    System = {
      lib,
      config,
      ...
    }: {
      inherit options;
      config = lib.mkIf cfg.enable SystemConfig;
    };
  };
}
