{
  config,
  lib,
  system,
  pkgs-list,
  tools,
  ...
} @ Inputs: let
  name = "sys";
  subfolder = "sys";
  repo = "nix";
  branch = "unstable";
  packages = pkgs-list.${repo}.${branch};
  imports = [
    "bootloader"
    "lang"
    "users"
    "hardware"
    "networking"
    "filesystems"
  ];
  oldPathNames = [];
  pathNames = oldPathNames ++ [name];
  fullPath = lib.concatStringsSep "." pathNames;
  cfg = config.${fullPath};
  options.${fullPath} = {
    enable = lib.mkEnableOption "Enables and configures system related settings.";
    version = lib.mkOption {
      type = lib.types.str;
      default = "25.11";
      description = "The system state version.";
    };
    bootloader = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      description = "Enables and configures bootloader related settings.";
      default =
        cfg.bootloader
        // {
          enable = lib.mkEnableOption "Enables bootloader related settings.";
        };
    };
    lang = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      description = "Enables and configures language related settings.";
      default =
        cfg.lang
        // {
          enable = lib.mkEnableOption "Enables language related settings.";
        };
    };
    users = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      description = "Enables and configures user related settings.";
      default =
        cfg.users
        // {
          enable = lib.mkEnableOption "Enables user related settings.";
        };
    };
    hardware = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      description = "Enables and configures hardware related settings.";
      default =
        cfg.hardware
        // {
          enable = lib.mkEnableOption "Enables hardware related settings.";
        };
    };
    networking = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      description = "Enables and configures networking related settings.";
      default =
        cfg.networking
        // {
          enable = lib.mkEnableOption "Enables networking related settings.";
        };
    };
    filesystems = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      description = "Enables and configures filesystem related settings.";
      default =
        cfg.filesystems
        // {
          enable = lib.mkEnableOption "Enables filesystem related settings.";
        };
    };
  };
  settings.${fullPath} = {
    lang = {
      enable = cfg.enable && cfg.lang.enable;
    };
    users = {
      enable = cfg.enable && cfg.users.enable;
    };
    hardware = {
      enable = cfg.enable && cfg.hardware.enable;
    };
    networking = {
      enable = cfg.enable && cfg.networking.enable;
    };
  };
  inheritSettings = tools.inheritSettings {
    pathNames = pathNames;
    imports = imports;
    settings = settings;
  };
in {
  inherit options;
  imports = map (file:
    (import ./${subfolder}/${file}.nix
      {
        inherit config lib pkgs-list tools;
        inherit (Inputs) inputs;
        oldPathNames = pathNames;
      }).config.System)
  imports;
  config =
    inheritSettings
    // {
      system.stateVersion = config.${fullPath}.version;
      nix.settings.experimental-features = ["nix-command" "flakes"];
      boot.kernelPackages = packages.linuxPackages_latest;
    };
}
