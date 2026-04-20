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
    name = "browsers";
    subfolder = "browsers";
    imports = [
      "firefox"
      "chromium"
      "zen"
    ];
    extras = {
    };
    options = {
      enable = lib.mkEnableOption "Enables ${name} program and related settings.";
    };
    settings = {
      firefox.enable = true;
      chromium.enable = true;
      zen.enable = true;
    };
  };
in (tools.fullModule {
  inherit (moduleParams) config lib pkgs-list parentPathAsList tools;
  inherit (moduleParams) name subfolder main-repo branch extras imports specialImports options settings;
  inherit (moduleParams) packages currentPathAsList currentDirPath cfg inheritedSettings Common;
})
