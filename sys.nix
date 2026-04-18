{
  config,
  lib,
  pkgs-list,
  tools,
  baseSettings,
  parentPathAsList ? [],
  ...
}: let
  ######  # user defined
  name = "sys";
  subfolder = "sys";
  repo = "nix";
  branch = "unstable";
  imports = [
    "bootloader"
    "lang"
    "users"
    "hardware"
    "networking"
    "filesystems"
  ];
  options = {
    version = lib.mkOption {
      type = lib.types.str;
      default = "25.11";
      description = "The system state version.";
    };
  };
  newSettings.${name} = {
    lang = {
      timeZone = "America/Toronto";
      defaultLang = "en_US.UTF-8";
      keyboardLayout = "fr";
    };
  };
  settings = (lib.recursiveUpdate baseSettings newSettings).${name};
  ######  # computed
  packages = pkgs-list.${repo}.${branch};
  currentPathAsList = parentPathAsList ++ [name];
  currentDirPath = lib.path.subpath.join (lib.lists.flatten ["./." parentPathAsList]);
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
  System = {
    system.stateVersion = config.sys.version;
    nix.settings.experimental-features = ["nix-command" "flakes"];
    boot.kernelPackages = packages.linuxPackages_latest;
  };
  ######  # computed
  SystemConfig =
    Common
    // System;
in
  tools.contextualModule {
    inherit lib config tools; # deps
    inherit subfolder currentPathAsList pkgs-list currentDirPath; # generated
    inherit options imports; # user defined
    togglable = false;
    context = "System";
    Config = SystemConfig;
  }
