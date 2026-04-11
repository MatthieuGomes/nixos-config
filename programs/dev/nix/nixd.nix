{
  config,
  lib,
  pkgs-list,
  oldPathNames,
  tools,
  ...
} @ Inputs: let
  name = "nixd";
  main-repo = "nix";
  branch = "latest";
  packages = Inputs.pkgs-list.${main-repo}.${branch};
  pathNames = oldPathNames ++ [name];
  fullPath = lib.concatStringsSep "." pathNames;
  cfg = config.${name};
  Common = {};
  options.${name} = {
    enable = lib.mkEnableOption "Enables and configures Nixd.";
  };
  Home = {
    home.packages = with packages; [
      nixd
    ];
  };
  System = {};
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
      config =
        lib.mkIf cfg.enable SystemConfig;
    };
  };
}
