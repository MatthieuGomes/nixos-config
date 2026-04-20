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
    name = "filesystems";
    subfolder = "filesystems";
    imports = [
      "ntfs"
      "exfat"
      "btrfs"
    ];
    options = {
      enable = lib.mkEnableOption "Enables ${name} related settings.";
    };
    settings = {
      ntfs.enable = true;
      exfat.enable = true;
      btrfs.enable = true;
    };
  };
in (tools.fullModule {
  inherit (moduleParams) config lib pkgs-list parentPathAsList tools;
  inherit (moduleParams) name togglable subfolder main-repo branch extras imports specialImports options settings;
  inherit (moduleParams) packages currentPathAsList currentDirPath cfg inheritedSettings Common;
})
