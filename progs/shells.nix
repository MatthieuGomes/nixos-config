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
    name = "shells";
    subfolder = "shells";
    main-repo = "nix";
    branch = "latest";
    imports = [
      "zsh"
    ];
    extras = {
      aliases = {
        nrs = "sudo nixos-rebuild switch";
        ls = "ls --color -ah";
        ".." = "cd ..";
        yazi = "y";
        myip = "myip";
      };
    };
    options = {
      enable = lib.mkEnableOption "Enables ${name} program and related settings.";
    };
    settings = {
      zsh = {
        enable = true;
        aliases = extras.aliases;
      };
    };
  };
in (tools.fullModule {
  inherit (moduleParams) config lib pkgs-list parentPathAsList tools;
  inherit (moduleParams) name togglable subfolder main-repo branch extras imports specialImports options settings;
  inherit (moduleParams) packages currentPathAsList currentDirPath cfg inheritedSettings Common;
})
