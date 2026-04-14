{
  config,
  lib,
  pkgs-list,
  parentPathAsList,
  tools,
  ...
} @ Inputs: let
  name = "exfat";
  main-repo = "nix";
  branch = "latest";
  packages = pkgs-list.${main-repo}.${branch};
  currentPathAsList = parentPathAsList ++ [name];
  cfg = config.sys.filesystems.${name};
  options = {
    enable = lib.mkEnableOption "Enables and configures ${name} filesystem support.";
  };
  Common = {
  };
  Home = {
  };
  System = {
    environment.systemPackages = with packages; [
      ntfs3g
      ntfsprogs
    ];
    boot.supportedFilesystems = {
      ntfs = true;
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
