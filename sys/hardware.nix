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
    togglable = false;
    subfolder = "hardware";
    main-repo = "nix";
    branch = "latest";
    imports = [
      "nvidia"
      "printer"
      "sound"
      "bluetooth"
    ];
    options = {
      enable = lib.mkEnableOption "Enables ${name} related settings.";
    };
    settings = {
      nvidia.enable = true; # TODO FIX : module to fix once a stable and working nvidia version is available
      printer.enable = true;
      sound.enable = true;
      bluetooth.enable = true;
    };
  };
in (tools.fullModule rec {
  inherit (moduleParams) config lib pkgs-list parentPathAsList tools;
  inherit (moduleParams) name togglable subfolder main-repo branch extras imports specialImports options settings;
  inherit (moduleParams) packages currentPathAsList currentDirPath cfg inheritedSettings Common;
  System = {
    services = {
      libinput.enable = true; # TODO FIX - not sure where to put it yet
    };
    environment.systemPackages = with packages; [
      lshw
      usbutils
    ];
  };
})
