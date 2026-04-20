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
    name = "desktop";
    subfolder = "desktop";
    main-repo = "nix";
    branch = "latest";
    imports = [
      "plasma"
      "klassy"
      "rofi"
    ];
    extras = {
    };
    options = {
      enable = lib.mkEnableOption "Enables ${name} program and related settings.";
    };
    settings = {
      plasma.enable = true;
      klassy.enable = true;
      rofi.enable = true;
    };
  };
in (tools.fullModule {
  inherit (moduleParams) config lib pkgs-list parentPathAsList tools;
  inherit (moduleParams) name subfolder main-repo branch extras imports specialImports options settings;
  inherit (moduleParams) packages currentPathAsList currentDirPath cfg inheritedSettings Common;
})
