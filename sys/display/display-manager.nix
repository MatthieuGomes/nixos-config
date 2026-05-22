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
    name = "display-manager";
    main-repo = "nix";
    branch = "latest";
    togglable = false;
    options = {
      enable = lib.mkEnableOption "Enables ${name} related settings.";
    };
  };
in (tools.fullModule rec {
  inherit (moduleParams) config lib pkgs-list parentPathAsList tools;
  inherit (moduleParams) name togglable subfolder main-repo branch extras imports specialImports options settings;
  inherit (moduleParams) packages currentPathAsList currentDirPath cfg inheritedSettings Common;
  System = {
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      settings = {
        General = {
          InputMethod = "qtvirtualkeyboard";
        };
      };
    };
    environment.systemPackages = with packages.kdePackages; [
      qtvirtualkeyboard
      sddm-kcm
    ];
  };
})
