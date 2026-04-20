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
    name = "oh-my-zsh";
    options = {
      enable = lib.mkEnableOption "Enables ${name} program and related settings.";
      plugins = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = "A list of Oh My Zsh plugins to enable.";
        default = [];
      };
    };
  };
in (tools.fullModule rec {
  inherit (moduleParams) config lib pkgs-list parentPathAsList tools;
  inherit (moduleParams) name subfolder main-repo branch extras imports specialImports options settings;
  inherit (moduleParams) packages currentPathAsList currentDirPath cfg inheritedSettings Common;
  Home = {
    programs.zsh.oh-my-zsh = {
      enable = true;
      plugins = cfg.plugins;
    };
  };
})
