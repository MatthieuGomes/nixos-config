{
  config,
  lib,
  pkgs-list,
  parentPathAsList,
  tools,
  ...
}: let
  ######  # user defined
  name = "hardware";
  subfolder = "hardware";
  main-repo = "nix";
  branch = "latest";
  imports = [
    "nvidia"
    "printer"
    "sound"
    # "bluetooth"
  ];
  options = {
    enable = lib.mkEnableOption "Enables ${name} related settings.";
  };
  settings = {
    nvidia.enable = false; # FIX : module to fix once a stable and working nvidia version is available
    printer.enable = true;
    sound.enable = true;
    # bluetooth.enable = true; #TODO : move bluetooth to its own module
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
  };
  System = {
    # TODO : move bluetooth to its own module
    hardware = {
      bluetooth.enable = true;
    };
    services.blueman.enable = true;

    services = {
      libinput.enable = true; # TODO : FIX - not sure where to put it yet
    };
    # FIX : dont know where to put that : temporary here
    environment.systemPackages = with packages; [
      lshw
      iw
      usbutils
    ];
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
