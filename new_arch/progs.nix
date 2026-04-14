{
  config,
  lib,
  pkgs-list,
  tools,
  baseSettings,
  ...
} @ Inputs: let
  name = "progs";
  subfolder = "progs";
  repo = "nix";
  branch = "latest";
  packages = pkgs-list.${repo}.${branch};
  imports = [
    # "dev"
    # "misc"
    # "shells"
    # "office"
    # "desktop"
  ];
  # Temporary
  homeImport = [
    # "browsers"
  ];
  oldPathNames = [];
  pathNames = oldPathNames ++ [name];
  fullPath = lib.concatStringsSep "." pathNames;
  currentDirPath = lib.path.subpath.join (lib.lists.flatten ["./." oldPathNames]);
  newSettings.${name} = {
  };
  settings = (lib.recursiveUpdate baseSettings newSettings).${name};
  inheritedSettings = tools.inheritSettings {
    inherit settings;
    inherit pathNames;
    inherit imports;
  };
  Common =
    inheritedSettings
    // {
    };
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

  HomeConfig = Common // Home;
  SystemConfig = Common // System;
in {
  config = {
    Home = {
      lib,
      config,
      ...
    }: {
      imports = tools.contextModuleImport {
        imports =
          imports
          ++ homeImport;
        inherit subfolder tools pathNames lib config pkgs-list currentDirPath;
        inherit (Inputs) inputs;
        context = "Home";
      };
      config = HomeConfig;
    };
    System = {
      lib,
      config,
      ...
    }: {
      imports = tools.contextModuleImport {
        inherit imports subfolder tools pathNames lib config pkgs-list currentDirPath;
        inherit (Inputs) inputs;
        context = "System";
      };
      config = SystemConfig;
    };
  };
}
