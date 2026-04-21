{
  config,
  lib,
  pkgs-list,
  tools,
  baseSettings,
  parentPathAsList ? [],
  ...
}: let
  moduleParams = tools.moduleParams rec {
    inherit config lib pkgs-list parentPathAsList tools;
    name = "progs";
    togglable = false;
    subfolder = "progs";
    main-repo = "nix";
    branch = "latest";
    imports = [
      "dev"
      "misc"
      "shells"
      "office"
      "desktop"
      "browsers"
      "terminals"
      "editors"
      "gaming"
    ];
    settings = (lib.recursiveUpdate baseSettings {}).${name};
  };
in (tools.fullModule {
  inherit (moduleParams) config lib pkgs-list parentPathAsList tools;
  inherit (moduleParams) name togglable subfolder main-repo branch extras imports specialImports options settings;
  inherit (moduleParams) packages currentPathAsList currentDirPath cfg inheritedSettings Common;
})
