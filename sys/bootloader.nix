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
    name = "bootloader";
    togglable = false;
    subfolder = "bootloader";
    imports = [
      "grub"
      "plymouth"
    ];
    options = {
      enable = lib.mkEnableOption "Enables ${name} related settings.";
    };
    settings = {
      grub.enable = true;
      plymouth.enable = true;
    };
  };
in (tools.fullModule rec {
  inherit (moduleParams) config lib pkgs-list parentPathAsList tools;
  inherit (moduleParams) name togglable subfolder main-repo branch extras imports specialImports options settings;
  inherit (moduleParams) packages currentPathAsList currentDirPath cfg inheritedSettings Common;
  System = let
  in {
    boot = {
      loader = {
        efi = {
          canTouchEfiVariables = true;
        };
      };
    };
  };
})
