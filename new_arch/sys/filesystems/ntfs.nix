{
  config,
  lib,
  pkgs-list,
  oldPathNames,
  tools,
  ...
} @ Inputs: let
  name = "ntfs";
  main-repo = "nix";
  branch = "latest";
  packages = pkgs-list.${main-repo}.${branch};
  pathNames = oldPathNames ++ [name];
  fullPath = lib.concatStringsSep "." pathNames;
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
      exfat
      exfatprogs
    ];
    boot.supportedFilesystems = {
      exfat = true;
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
