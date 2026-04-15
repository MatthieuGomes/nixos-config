# TODO : FIX !!!
{
  config,
  lib,
  pkgs-list,
  parentPathAsList,
  tools,
  ...
}: let
  ######  # user defined
  name = "nvidia";
  subfolder = null;
  main-repo = null;
  branch = null;
  imports = null;
  options = {
    enable = lib.mkEnableOption "Enables and configures ${name} hardware support.";
  };
  settings = null;
  ######  # computed
  packages =
    if main-repo != null && branch != null
    then pkgs-list.${main-repo}.${branch}
    else null;
  currentPathAsList = parentPathAsList ++ [name];
  currentDirPath = lib.path.subpath.join (lib.lists.flatten ["./." parentPathAsList]);
  cfg = config.sys.hardware.${name};
  inheritedSettings =
    if imports != null || settings != null
    then
      tools.inheritSettings {
        inherit currentPathAsList imports settings;
      }
    else {
    };

  Common =
    inheritedSettings
    // {
    };
  ######  # user defined
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
  ######  # computed
  HomeConfig = Common // Home;
  SystemConfig = Common // System;
in {
  config = {
    Home = tools.contextualModule {
      inherit lib config tools; # deps
      inherit subfolder currentPathAsList pkgs-list cfg currentDirPath; # generated
      inherit imports options; # user defined
      context = "Home";
      Config = HomeConfig;
    };
    System = tools.contextualModule {
      inherit lib config tools; # deps
      inherit subfolder currentPathAsList pkgs-list cfg currentDirPath; # generated
      inherit imports options; # user defined
      context = "System";
      Config = SystemConfig;
    };
  };
}
