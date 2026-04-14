{
  config,
  lib,
  pkgs-list,
  parentsPathList,
  tools,
  ...
} @ Inputs: let
  name = "filesystems";
  subfolder = "filesystems";
  main-repo = "nix";
  branch = "latest";
  packages = pkgs-list.${main-repo}.${branch};
  pathNames = parentsPathList ++ [name];
  currentDirPath = lib.path.subpath.join (lib.lists.flatten (lib.lists.flatten ["./." parentsPathList]));
  cfg = config.sys.${name};
  imports = [
    "ntfs"
    "exfat"
    "btrfs"
  ];
  options = {
    enable = lib.mkEnableOption "Enables ${name} related settings.";
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
      options = tools.inheritOptions {
        inherit pathNames options;
      };
      imports = tools.contextModuleImport {
        inherit imports subfolder tools pathNames lib config pkgs-list currentDirPath;
        inherit (Inputs) inputs;
        context = "Home";
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
      imports = tools.contextModuleImport {
        inherit imports subfolder tools pathNames lib config pkgs-list currentDirPath;
        inherit (Inputs) inputs;
        context = "System";
      };
      config = lib.mkIf cfg.enable SystemConfig;
    };
  };
}
