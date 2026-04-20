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
    name = "rofi";
    main-repo = "nix";
    branch = "latest";
    options = {
      enable = lib.mkEnableOption "Enables ${name} program and related settings.";
    };
  };
in (tools.fullModule rec {
  inherit (moduleParams) config lib pkgs-list parentPathAsList tools;
  inherit (moduleParams) name subfolder main-repo branch imports options settings extras;
  inherit (moduleParams) packages currentPathAsList currentDirPath cfg inheritedSettings Common;
  Home = {
    programs.rofi = {
      enable = true;
      terminal = "/${packages.ghostty}/bin/ghostty";
      theme = "Arc-Dark";
      modes = ["drun" "ssh" "run" "calc"];
      plugins = with packages; [
        rofi-calc
      ];
    };
  };
})
