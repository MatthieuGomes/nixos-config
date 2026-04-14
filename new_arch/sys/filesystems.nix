{
  config,
  lib,
  pkgs-list,
  oldPathNames,
  tools,
  ...
} @ Inputs: let
  name = "filesystems";
  subfolder = "filesystems";
  main-repo = "nix";
  branch = "latest";
  packages = pkgs-list.${main-repo}.${branch};
  pathNames = oldPathNames ++ [name];
  fullPath = lib.concatStringsSep "." pathNames;
  cfg = config.sys.${name};
  imports = [
    "ntfs"
    # "exfat"
    # "btrfs"
  ];
  options.sys.${name} = {
    enable = lib.mkEnableOption "Enables ${name} related settings.";
    # exfat.enable = lib.mkEnableOption "Enables and configures exFAT filesystem support.";
    # btrfs.enable = lib.mkEnableOption "Enables and configures Btrfs filesystem support.";
  };
  settings = {
    ntfs.enable = true;
    exfat.enable = true;
    btrfs.enable = true;
  };
  inheritedSettings = tools.inheritSettings {
    inherit pathNames imports settings;
  };
  Common =
    inheritedSettings
    // {
    };
  Home = {
  };
  System = {
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
      imports = map (file:
        (import ./${subfolder}/${file}.nix {
          inherit config lib pkgs-list tools;
          inherit (Inputs) inputs;
          oldPathNames = pathNames;
        }).config.Home)
      imports;
      config = lib.mkIf cfg.enable HomeConfig;
    };
    System = {
      lib,
      config,
      ...
    }: {
      inherit options;
      imports = map (file:
        (import ./${subfolder}/${file}.nix {
          inherit config lib pkgs-list tools;
          inherit (Inputs) inputs;
          oldPathNames = pathNames;
        }).config.System)
      imports;
      config = lib.mkIf cfg.enable SystemConfig;
    };
  };
}
