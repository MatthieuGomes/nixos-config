{
  config,
  lib,
  pkgs-list,
  tools,
  baseSettings,
  parentPathAsList ? [],
  ...
}: let
  moduleParams = tools.moduleParams rec {
    inherit config lib pkgs-list parentPathAsList tools;
    name = "progs";
    togglable = false;
    subfolder = "progs";
    main-repo = "nix";
    branch = "latest";
    imports = [
      "dev"
      "misc"
      "shells"
      "office"
      "desktop"
      "browsers"
      "terminals"
      "editors"
    ];
    settings = (lib.recursiveUpdate baseSettings {}).${name};
  };
in (tools.fullModule rec {
  inherit (moduleParams) config lib pkgs-list parentPathAsList tools;
  inherit (moduleParams) name togglable subfolder main-repo branch extras imports specialImports options settings;
  inherit (moduleParams) packages currentPathAsList currentDirPath cfg inheritedSettings Common;
  Home = {
    programs = {
      thunderbird = {
        enable = true; # Office
        profiles = {}; # Office
      };
    };
  };
  System = {
    environment.systemPackages = with packages; [
      mangohud # Gaming
      plocate # dev Misc
      mlocate # dev Misc
      xdotool # dev Misc
      protonup-ng # Gaming
      meld # dev Misc
      wget # dev Misc
    ];
    environment.sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/user/.steam/root/compatibilitytools.d"; # Gaming
    };
    programs = {
      gamemode.enable = true; # Gaming
      steam = {
        # Gaming
        enable = true; # Gaming
        gamescopeSession.enable = true; # Gaming
      };
    };
  };
})
