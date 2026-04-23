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
    name = "tuis";
    subfolder = "tuis";
    imports = [
      "yazi"
      "lazygit"
      "lazydocker"
    ];
    options = {
      enable = lib.mkEnableOption "Enables ${name} program and related settings.";
    };
    settings = {
      yazi.enable = true;
      lazygit.enable = true && config.progs.dev.git.enable;
      lazydocker.enable = true && config.progs.dev.virtualization.docker.enable;
    };
  };
in (tools.fullModule {
  inherit (moduleParams) config lib pkgs-list parentPathAsList tools;
  inherit (moduleParams) name togglable subfolder main-repo branch extras imports specialImports options settings;
  inherit (moduleParams) packages currentPathAsList currentDirPath cfg inheritedSettings Common;
})
