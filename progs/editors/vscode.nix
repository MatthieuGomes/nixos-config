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
    name = "vscode";
    main-repo = "nix";
    branch = "unstable";
    options = {
      enable = lib.mkEnableOption "Enables ${name} program and related settings.";
    };
    extras = {
    };
  };
in (tools.fullModule rec {
  inherit (moduleParams) config lib pkgs-list parentPathAsList tools;
  inherit (moduleParams) name togglable subfolder main-repo branch extras imports specialImports options settings;
  inherit (moduleParams) packages currentPathAsList currentDirPath cfg inheritedSettings Common;
  Home = {
    programs.vscode = {
      enable = true;
      package = packages.vscode;
      mutableExtensionsDir = true;
      # profiles.Default={

      # };
    };
  };
})
