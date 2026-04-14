{
  config,
  lib,
  pkgs-list,
  oldPathNames,
  tools,
  ...
} @ Inputs: let
  name = "hardware";
  subfolder = "hardware";
  main-repo = "nix";
  branch = "latest";
  packages = pkgs-list.${main-repo}.${branch};
  pathNames = oldPathNames ++ [name];
  currentDirPath = lib.path.subpath.join (lib.lists.flatten ["./." oldPathNames]);
  cfg = config.sys.${name};
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
  inheritedSettings = tools.inheritSettings {
    inherit pathNames imports settings;
  };
  Common =
    inheritedSettings
    // {
    };
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
        inherit pathNames options;
      };
      imports = tools.contextModuleImport {
        inherit imports subfolder tools pathNames lib config pkgs-list currentDirPath;
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
        inherit pathNames options;
      };
      imports = tools.contextModuleImport {
        inherit imports subfolder tools pathNames lib config pkgs-list currentDirPath;
        inherit (Inputs) inputs;
        context = "System";
      };
      config = lib.mkIf cfg.enable SystemConfig;
    };
  };
}
