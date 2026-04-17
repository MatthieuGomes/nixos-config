{
  config,
  lib,
  pkgs-list,
  parentPathAsList,
  tools,
  ...
}: let
  ######  # user defined
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
  extras = {
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
  ######  # computed
  packages =
    if main-repo != null && branch != null
    then pkgs-list.${main-repo}.${branch}
    else null;
  currentPathAsList = parentPathAsList ++ [name];
  currentDirPath = lib.path.subpath.join (lib.lists.flatten ["./." parentPathAsList]);
  cfg = tools.inheritConfig {
    inherit config currentPathAsList;
  };
  inheritedSettings =
    if imports != null || settings != null
    then
      tools.inheritSettings {
        inherit currentPathAsList imports settings;
      }
    else {
    };
  Common =
    inheritedSettings
    // {
    };
  ######  # user defined
  Home = {
    # home.file.".p10k.zsh".text = "${builtins.readFile "${./${subfolder}/static/.p10k.zsh}"}";
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
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme"; # FEAT : Maybe to a file owned by me ?
        }
        {
          name = "fzf-tab";
          src = "${packages.zsh-fzf-tab}/share/fzf-tab";
        }
      ];
      # FIXME : move to a dedicated file
      initContent = ''

        source ~/nixos-config/new_arch/progs/shells/${subfolder}/static/.p10k.zsh

        zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
        zstyle ':completion:*' menu no
        zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -a --color $realpath'

        function y() {
          local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
          yazi "$@" --cwd-file="$tmp"
          IFS= read -r -d \'\' cwd < "$tmp"
          [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
          rm -f -- "$tmp"
        }

        function myip(){
          echo $(ip addr show wlp0s20f3 | grep -oP 'inet \K[^/]+')
        }

      '';

      #  zstyle ':completion:*' menu no
      # FIXME : move new aliases to shells extras
      shellAliases =
        cfg.aliases
        // {
          yazi = "y";
          myip = "myip";
        };
    };
  };
  System = {
    programs.zsh.enable = true;
  };
  ######  # computed
  HomeConfig = Common // Home;
  SystemConfig = Common // System;
in {
  config = {
    Home = tools.contextualModule {
      inherit lib config tools; # deps
      inherit subfolder currentPathAsList pkgs-list cfg currentDirPath; # generated
      inherit imports options; # user defined
      context = "Home";
      Config = HomeConfig;
    };
    System = tools.contextualModule {
      inherit lib config tools; # deps
      inherit subfolder currentPathAsList pkgs-list cfg currentDirPath; # generated
      inherit imports options; # user defined
      context = "System";
      Config = SystemConfig;
    };
  };
}
