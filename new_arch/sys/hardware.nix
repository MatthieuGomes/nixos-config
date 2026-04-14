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
  fullPath = lib.concatStringsSep "." pathNames;
  cfg = config.sys.${name};
  imports = [
    "nvidia"
    # "printer"
    "sound"
    # "bluetooth"
  ];
  options.sys.${name} = {
    enable = lib.mkEnableOption "Enables ${name} related settings.";
  };
  settings = {
    nvidia.enable = false; # FIX : module to fix once a stable and working nvidia version is available
    printer.enable = true;
    sound.enable = true;
    bluetooth.enable = true;
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
      inherit options;
      imports = map (file:
        (import ./${subfolder}/${file}.nix {
          inherit config lib pkgs-list tools;
          inherit (Inputs) inputs;
          oldPathNames = pathNames;
        }).config.Home)
      imports;
      config = lib.mkIf cfg.enable HomeConfig;
    };
    System = {
      lib,
      config,
      ...
    }: {
      inherit options;
      imports = map (file:
        (import ./${subfolder}/${file}.nix {
          inherit config lib pkgs-list tools;
          inherit (Inputs) inputs;
          oldPathNames = pathNames;
        }).config.System)
      imports;
      config = lib.mkIf cfg.enable SystemConfig;
    };
  };
}
