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
      # TODO : add a default browser setting to choose between firefox, chromium and zen
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
in (tools.fullModule rec {
  inherit (moduleParams) config lib pkgs-list parentPathAsList tools;
  inherit (moduleParams) name togglable subfolder main-repo branch extras imports specialImports options settings;
  inherit (moduleParams) packages currentPathAsList currentDirPath cfg inheritedSettings Common;
  # System = {
  #   environment.sessionVariables.DEFAULT_BROWSER = "${pkgs-list.nix.latest.firefox}/bin/firefox";
  #   xdg.mime.enable = true;
  #   xdg.mime.defaultApplications = {
  #     "text/html" = "firefox.desktop";
  #     "x-scheme-handler/http" = "firefox.desktop";
  #     "x-scheme-handler/https" = "firefox.desktop";
  #     "x-scheme-handler/about" = "firefox.desktop";
  #     "x-scheme-handler/unknown" = "firefox.desktop";
  #   };
  # };
})
