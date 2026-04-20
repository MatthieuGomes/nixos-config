{
  config,
  lib,
  pkgs-list,
  parentPathAsList,
  tools,
  ...
}: let
  moduleParams = tools.moduleParams rec {
    inherit config lib pkgs-list parentPathAsList tools;
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
  };
in (tools.fullModule rec {
  inherit (moduleParams) config lib pkgs-list parentPathAsList tools;
  inherit (moduleParams) name subfolder main-repo branch extras imports specialImports options settings;
  inherit (moduleParams) packages currentPathAsList currentDirPath cfg inheritedSettings Common;
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
})
