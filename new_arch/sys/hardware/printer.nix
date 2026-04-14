{
  config,
  lib,
  pkgs-list,
  oldPathNames,
  tools,
  ...
} @ Inputs: let
  name = "printer";
  main-repo = "nix";
  branch = "latest";
  packages = pkgs-list.${main-repo}.${branch};
  pathNames = oldPathNames ++ [name];
  fullPath = lib.concatStringsSep "." pathNames;
  cfg = config.sys.hardware.${name};
  options = {
    enable = lib.mkEnableOption "Enables and configures ${name} hardware support.";
  };
  Common = {
  };
  Home = {
  };
  System = {
    services.printing.enable = true;
    environment.systemPackages = with packages; [
      cnijfilter2
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
      options = tools.inheritOptions {
        inherit pathNames options;
      };
      config = lib.mkIf cfg.enable HomeConfig;
    };
    System = {
      lib,
      config,
      ...
    }: {
      options = tools.inheritOptions {
        inherit pathNames options;
      };
      config = lib.mkIf cfg.enable SystemConfig;
    };
  };
}
