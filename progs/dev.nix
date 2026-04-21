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
    name = "dev";
    subfolder = "dev";
    main-repo = "nix";
    branch = "latest";
    imports = [
      "boot"
      "network"
      "git"
      "virtualization"
      "lang"
    ];
    options = {
      enable = lib.mkEnableOption "Enables ${name} program and related settings.";
    };
    settings = {
      nix.enable = true;
      boot.enable = true;
      network.enable = true;
      git.enable = true;
      virtualization.enable = true;
      lang.enable = true;
    };
  };
in (tools.fullModule {
  inherit (moduleParams) config lib pkgs-list parentPathAsList tools;
  inherit (moduleParams) name togglable subfolder main-repo branch extras imports specialImports options settings;
  inherit (moduleParams) packages currentPathAsList currentDirPath cfg inheritedSettings Common;
})
