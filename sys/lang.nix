{
  config,
  lib,
  pkgs-list,
  parentPathAsList,
  tools,
  ...
}: let
  moduleParams = tools.moduleParams rec {
    inherit config lib pkgs-list parentPathAsList tools;
    name = "lang";
    togglable = false;
    main-repo = "nix";
    branch = "latest";
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
  };
in (tools.fullModule rec {
  inherit (moduleParams) config lib pkgs-list parentPathAsList tools;
  inherit (moduleParams) name togglable subfolder main-repo branch extras imports specialImports options settings;
  inherit (moduleParams) packages currentPathAsList currentDirPath cfg inheritedSettings Common;
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
  Home =
    {
    }
    // tools.ifExists config "config.progs.desktop.plasma" {
      programs.plasma.input.keyboard = {
        model = "pc105";
        layouts = [
          {
            layout = cfg.keyboardLayout;
            displayName = "FR - AZERTY";
          }
          {
            layout = "us";
            displayName = "US - QWERTY";
          }
        ];
      };
    };
})
