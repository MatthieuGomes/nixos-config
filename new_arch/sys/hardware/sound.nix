{
  config,
  lib,
  pkgs-list,
  parentsPathList,
  tools,
  ...
} @ Inputs: let
  name = "sound";
  main-repo = "nix";
  branch = "latest";
  packages = pkgs-list.${main-repo}.${branch};
  currentPathAsList = parentsPathList ++ [name];
  cfg = config.sys.hardware.${name};
  options = {
    enable = lib.mkEnableOption "Enables and configures ${name} hardware support.";
  };
  Common = {
  };
  Home = {
  };
  System = {
    services.pipewire = {
      enable = true;
      pulse.enable = true;
    };
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
      options = tools.inheritOptions {
        inherit currentPathAsList options;
      };
      config = lib.mkIf cfg.enable HomeConfig;
    };
    System = {
      lib,
      config,
      ...
    }: {
      options = tools.inheritOptions {
        inherit currentPathAsList options;
      };
      config = lib.mkIf cfg.enable SystemConfig;
    };
  };
}
