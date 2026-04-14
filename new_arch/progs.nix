{
  config,
  lib,
  pkgs-list,
  tools,
  settings,
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
  inheritedSettings = tools.inheritSettings {
    settings = settings.progs;
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
      imports =
        map (file:
          (import ./${subfolder}/${file}.nix {
            inherit config lib pkgs-list tools;
            inherit (Inputs) inputs;
            oldPathNames = pathNames;
          }).config.Home)
        (imports
          ++ homeImport);
      config = HomeConfig;
    };
    System = {
      lib,
      config,
      ...
    }: {
      imports = map (file:
        (import ./${subfolder}/${file}.nix {
          inherit config lib pkgs-list tools;
          inherit (Inputs) inputs;
          oldPathNames = pathNames;
        }).config.System)
      imports;
      config = SystemConfig;
    };
  };
}
