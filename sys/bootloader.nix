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
    options = {
      enable = lib.mkEnableOption "Enables ${name} related settings.";
    };
  };
in (tools.fullModule rec {
  inherit (moduleParams) config lib pkgs-list parentPathAsList tools;
  inherit (moduleParams) name togglable subfolder main-repo branch extras imports specialImports options settings;
  inherit (moduleParams) packages currentPathAsList currentDirPath cfg inheritedSettings Common;
  System = {
    boot.loader = {
      grub = {
        enable = true;
        devices = ["nodev"];
        efiSupport = true;
        useOSProber = true;
        extraEntries = ''
          ${builtins.readFile "${./${subfolder}/00_Arch_Btrfs}"}
          ${builtins.readFile "${./${subfolder}/99_UEFI_Firmware}"}
        '';
      };
      efi = {
        canTouchEfiVariables = true;
      };
    };
  };
})
