{
  config,
  lib,
  pkgs-list,
  parentsPathList,
  tools,
  ...
} @ Inputs: let
  name = "lang";
  main-repo = "nix";
  branch = "latest";
  packages = pkgs-list.${main-repo}.${branch};
  pathNames = parentsPathList ++ [name];
  cfg = config.sys.${name};
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
  Common = {
  };
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
