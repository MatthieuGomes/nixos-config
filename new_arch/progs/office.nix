{
  config,
  lib,
  pkgs-list,
  parentPathAsList,
  tools,
  ...
}: let
  ######  # user defined
  name = "office";
  subfolder = "office";
  main-repo = null;
  branch = null;
  imports = [
    # "libreoffice"
    # "qualculate"
  ];
  options = {
    enable = lib.mkEnableOption "Enables ${name} program and related settings.";
  };
  extras = {
  };
  settings = {
    libreoffice = {
      enable = cfg.enable && cfg.libreoffice;
    };
    qualculate = {
      enable = cfg.enable && cfg.qualculate;
    };
  };
  ######  # computed
  packages =
    if main-repo != null && branch != null
    then pkgs-list.${main-repo}.${branch}
    else null;
  currentPathAsList = parentPathAsList ++ [name];
  currentDirPath = lib.path.subpath.join (lib.lists.flatten ["./." parentPathAsList]);
  cfg = tools.inheritConfig {
    inherit config currentPathAsList;
  };
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
