{
  config,
  lib,
  pkgs-list,
  tools,
  ...
} @ Inputs: let
  name = "progs";
  subfolder = "progs";
  repo = "nix";
  branch = "latest";
  packages = pkgs-list.${repo}.${branch};
  imports = [
    "dev"
    "misc"
    "shells"
    "office"
    "desktop"
  ];
  # Temporary
  homeImport = [
    "browsers"
  ];
  oldPathNames = [];
  pathNames = oldPathNames ++ [name];
  fullPath = lib.concatStringsSep "." pathNames;
  cfg = config.${fullPath};
  options.${fullPath} = {
    enable = lib.mkEnableOption "Enables and configures ${name}";
    dev = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      description = "Enables and configures development tools.";
      default =
        cfg.dev
        // {
          enable = lib.mkEnableOption "Enables development tools.";
        };
    };
    shells = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      description = "Enables and configures shells.";
      default =
        cfg.shells
        // {
          enable = lib.mkEnableOption "Enables shells.";
        };
    };
    misc = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      description = "Enables and configures miscellaneous tools.";
      default =
        cfg.misc
        // {
          enable = lib.mkEnableOption "Enables miscellaneous tools.";
        };
    };
    office = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      description = "Enables and configures office tools.";
      default =
        cfg.office
        // {
          enable = lib.mkEnableOption "Enables office tools.";
        };
    };
    browsers = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      description = "Enables and configures browsers.";
      default =
        cfg.browsers
        // {
          enable = lib.mkEnableOption "Enables browsers.";
        };
    };
    desktop = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      description = "Enables and configures desktop environment.";
      default =
        cfg.desktop
        // {
          enable = lib.mkEnableOption "Enables desktop environment.";
        };
    };
  };
  settings.${fullPath} = {
    enable = cfg.${fullPath}.enable;
    dev = cfg.${fullPath}.dev;
    shells = cfg.${fullPath}.shells;
    misc = cfg.${fullPath}.misc;
    office = cfg.${fullPath}.office;
    browsers = cfg.${fullPath}.browsers;
    desktop = cfg.${fullPath}.desktop;
  };
  inheritedSettings = tools.inheritSettings {
    pathNames = pathNames;
    imports = imports;
    settings = settings;
  };
  Common =
    inheritedSettings
    // {
    };
  Home = {
    progs.browsers = settings.${fullPath}.browsers;
    programs = {
      thunderbird = {
        enable = true;
        profiles = {};
      };
    };
  };
  System = {
    environment.systemPackages = with packages; [
      mangohud
      plocate
      mlocate
      xdotool
      protonup-ng
      meld
      wget
    ];
    environment.sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/user/.steam/root/compatibilitytools.d";
    };
    programs = {
      gamemode.enable = true;
      steam = {
        enable = true;
        gamescopeSession.enable = true;
      };
      virt-manager.enable = true;
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
      inherit options;
      imports =
        map (file:
          (import ./${subfolder}/${file}.nix {
            inherit config lib pkgs-list tools;
            inherit (Inputs) inputs;
            oldPathNames = pathNames;
          }).config.Home)
        (imports
          ++ homeImport);
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
