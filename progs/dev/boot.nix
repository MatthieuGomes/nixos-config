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
    name = "boot";
    subfolder = "boot";
    main-repo = "nix";
    branch = "latest";
    imports = [
      "efibootmgr"
      "gparted"
      "os-prober"
      "kde-partition-manager"
    ];
    options = {
      enable = lib.mkEnableOption "Enables ${name} program and related settings.";
    };
    settings = {
      efibootmgr.enable = true;
      gparted.enable = true;
      os-prober.enable = true;
      kde-partition-manager.enable = true;
    };
  };
in (tools.fullModule rec {
  inherit (moduleParams) config lib pkgs-list parentPathAsList tools;
  inherit (moduleParams) name togglable subfolder main-repo branch extras imports specialImports options settings;
  inherit (moduleParams) packages currentPathAsList currentDirPath cfg inheritedSettings Common;

  Home = {
    home.packages = with packages; [
      ddrescue
      squashfsTools
    ];
  };
})
