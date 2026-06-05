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
    name = "fstab";
    options = {
      enable = lib.mkEnableOption "Enables ${name} related settings.";
    };
  };
in (tools.fullModule {
  inherit (moduleParams) config lib pkgs-list parentPathAsList tools;
  inherit (moduleParams) name togglable subfolder main-repo branch extras imports specialImports options settings;
  inherit (moduleParams) packages currentPathAsList currentDirPath cfg inheritedSettings Common;
  System = {
    # fileSystems = {
    #   "Windows" = {
    #     device = "/dev/disk/by-uuid/8EE66173E6615C89";
    #     fsType = "ntfs";
    #     mountPoint = "/mnt/windows";
    #     options = ["defaults" "users" "nofail"];
    #   };
    #   "Shared" = {
    #     device = "/dev/disk/by-uuid/3C32D71A32D6D7CA";
    #     fsType = "ntfs";
    #     mountPoint = "/mnt/shared";
    #     options = ["defaults" "users" "nofail"];
    #   };
    # };
  };
})
