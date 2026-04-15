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
  name = "progs";
  subfolder = "progs";
  repo = "nix";
  branch = "latest";
  imports = [
    # "dev"
    "misc"
    "shells"
    "office"
    "desktop"
    "browsers"
  ];
  options = null;
  newSettings.${name} = {
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
  Home = {
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
  ######  # computed
  HomeConfig = Common // Home;
  SystemConfig = Common // System;
in {
  # FIXME : find a way to make more uniform with the other modules
  config = {
    Home = tools.contextualModule {
      inherit lib config tools; # deps
      inherit subfolder currentPathAsList pkgs-list currentDirPath; # generated
      inherit options imports; # user defined
      togglable = false;
      context = "Home";
      Config = HomeConfig;
    };
    System = tools.contextualModule {
      inherit lib config tools; # deps
      inherit subfolder currentPathAsList pkgs-list currentDirPath; # generated
      inherit options imports; # user defined
      togglable = false;
      context = "System";
      Config = SystemConfig;
    };
  };
}
