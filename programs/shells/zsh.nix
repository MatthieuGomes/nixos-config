{
  config,
  lib,
  pkgs-list,
  ...
}: let
  name = "zsh";
  subfolder = "zsh";
  repo = "nix";
  branch = "latest";
  packages = pkgs-list.${repo}.${branch};
  options.${name} = {
    enable = lib.mkEnableOption "Enable Zsh shell and its plugins.";
    oh-my-zsh.enable = lib.mkEnableOption "Enable Oh My Zsh framework.";
    aliases = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      description = "An attribute set of shell aliases to define.";
      default = {};
    };
  };
  cfg = config.${name};
  settings = {
    oh-my-zsh.enable = cfg.enable && cfg.oh-my-zsh.enable;
    fzf.enable = cfg.enable && cfg.fzf.enable;
    yazi.enable = cfg.enable;
  };
in {
  config = {
    Home = {
      lib,
      config,
      ...
    }: {
      inherit options;
      imports = map (file: ./${subfolder}/${file}) [
        "oh-my-zsh.nix"
        "yazi.nix"
        "fzf.nix"
      ];
      config = lib.mkIf cfg.enable {
        inherit (settings) oh-my-zsh fzf yazi;
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
          initContent = ''

            source ~/.p10k.zsh

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

          shellAliases =
            cfg.aliases
            // {
              yazi = "y";
              myip = "myip";
            };
        };
      };
    };
    System = {
      lib,
      config,
      ...
    }: {
      inherit options;
      config = lib.mkIf cfg.enable {
        programs.zsh.enable = true;
      };
    };
  };
}
