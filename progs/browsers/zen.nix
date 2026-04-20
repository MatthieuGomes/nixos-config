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
    name = "zen";
    options = {
      enable = lib.mkEnableOption "Enables ${name} program and related settings.";
    };
    specialImports = {
      Home = [pkgs-list.others.zen-browser.homeModules.beta];
    };
  };
in (tools.fullModule {
  inherit (moduleParams) config lib pkgs-list parentPathAsList tools;
  inherit (moduleParams) name togglable subfolder main-repo branch extras imports specialImports options settings;
  inherit (moduleParams) packages currentPathAsList currentDirPath cfg inheritedSettings Common;
  Home = {
    programs.zen-browser = {
      enable = true;
      # FEAT TODO: profiles, settings, etc.
    };
  };
})
