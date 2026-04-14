{
  config,
  lib,
  pkgs-list,
  parentPathAsList,
  tools,
  ...
} @ Inputs: let
  # Defined by user
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
  #####
  # programmatically generated first
  packages = pkgs-list.${main-repo}.${branch};
  currentPathAsList = parentPathAsList ++ [name];
  currentDirPath = lib.path.subpath.join (lib.lists.flatten ["./." parentPathAsList]);
  cfg = config.sys.${name};
  inheritedSettings = tools.inheritSettings {
    inherit currentPathAsList imports settings;
  };
  Common =
    inheritedSettings
    // {
    };
  #####
  # Second definition by user (can use packages and cfg)
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
  #####
  # programmatically generated then
  HomeConfig = Common // Home;
  SystemConfig = Common // System;
in {
  config = {
    Home = {
      lib,
      config,
      ...
    }: {
      options = tools.inheritOptions {
        inherit currentPathAsList options;
      };
      imports = tools.contextModuleImport {
        inherit imports subfolder tools currentPathAsList lib config pkgs-list currentDirPath;
        inherit (Inputs) inputs;
        context = "Home";
      };
      config = lib.mkIf cfg.enable HomeConfig;
    };
    System = {
      lib,
      config,
      ...
    }: {
      options = tools.inheritOptions {
        inherit currentPathAsList options;
      };
      imports = tools.contextModuleImport {
        inherit imports subfolder tools currentPathAsList lib config pkgs-list currentDirPath;
        inherit (Inputs) inputs;
        context = "System";
      };
      config = lib.mkIf cfg.enable SystemConfig;
    };
  };
}
