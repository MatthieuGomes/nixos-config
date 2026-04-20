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
    name = "zsh";
    subfolder = "zsh";
    main-repo = "nix";
    branch = "latest";
    imports = [
      "oh-my-zsh"
      "yazi"
      "fzf"
    ];
    options = {
      enable = lib.mkEnableOption "Enables ${name} program and related settings.";
      aliases = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        description = "An attribute set of shell aliases to define.";
        default = {};
      };
    };
    settings = {
      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "sudo"
        ];
      };
      fzf.enable = true;
      yazi.enable = true;
    };
  };
in (tools.fullModule rec {
  inherit (moduleParams) config lib pkgs-list parentPathAsList tools;
  inherit (moduleParams) name togglable subfolder main-repo branch extras imports specialImports options settings;
  inherit (moduleParams) packages currentPathAsList currentDirPath cfg inheritedSettings Common;
  Home = {
    home.file.".p10k.zsh".text = "${builtins.readFile "${./${subfolder}/.p10k.zsh}"}";
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      history = {
        path = "$HOME/.zsh_history";
        size = 10000;
        ignoreAllDups = true;
      };
      defaultKeymap = "emacs";
      plugins = [
        {
          name = "powerlevel10k";
          src = packages.zsh-powerlevel10k;
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        }
        {
          name = "fzf-tab";
          src = "${packages.zsh-fzf-tab}/share/fzf-tab";
        }
      ];
      initContent = "${builtins.readFile ./${subfolder}/init.zsh}";

      shellAliases = cfg.aliases;
    };
  };
  System = {
    programs.zsh.enable = true;
  };
})
