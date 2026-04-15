{
  config,
  lib,
  pkgs-list,
  parentPathAsList,
  tools,
  ...
}: let
  ######  # user defined
  name = "lang";
  subfolder = null;
  main-repo = "nix";
  branch = "latest";
  imports = null;
  options = {
    enable = lib.mkEnableOption "Enables ${name} related settings.";
    timeZone = lib.mkOption {
      type = lib.types.str;
      default = "America/Toronto";
      description = "The system time zone.";
    };
    defaultLang = lib.mkOption {
      type = lib.types.str;
      default = "en_US.UTF-8";
      description = "The system default locale.";
    };
    keyboardLayout = lib.mkOption {
      type = lib.types.str;
      default = "fr";
      description = "The system keyboard layout.";
    };
  };
  settings = null;
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
    time.timeZone = cfg.timeZone;
    i18n = {
      defaultLocale = cfg.defaultLang;
      extraLocaleSettings = {
        LC_TIME = "fr_FR.UTF-8";
      };
    };
    console.keyMap = cfg.keyboardLayout;
    services.xserver.xkb.layout = cfg.keyboardLayout;
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
