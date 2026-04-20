{
  config,
  lib,
  pkgs-list,
  parentPathAsList,
  tools,
  ...
}: let
  ######  # user defined
  name = "misc";
  subfolder = "misc";
  main-repo = "nix";
  branch = "latest";
  imports = [
    "ledger"
    "bambu-studio"
    "bitwarden"
    "fastfetch"
    "iso-image-writer"
    "vesktop"
    "kdeconnect"
  ];
  options = {
    enable = lib.mkEnableOption "Enables ${name} program and related settings.";
  };
  extras = {
  };
  settings = {
    ledger.enable = true;
    bambu-studio.enable = true;
    bitwarden.enable = true;
    fastfetch.enable = true;
    iso-image-writer.enable = true;
    kdeconnect.enable = true;
    vesktop.enable = true;
  };
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
    home.packages = with packages; [
      vlc # Misc
    ];
  };
  System = {
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
