{
  config,
  lib,
  pkgs-list,
  oldPathNames,
  tools,
  ...
} @ Inputs: let
  name = "sound";
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
