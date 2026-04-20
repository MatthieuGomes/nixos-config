{
  config,
  lib,
  pkgs-list,
  parentPathAsList,
  tools,
  ...
}: (tools.fullModule ((tools.moduleParams
    rec {
      inherit config lib pkgs-list parentPathAsList tools;
      name = "shells";
      subfolder = "shells";
      main-repo = "nix";
      branch = "latest";
      imports = [
        "zsh"
      ];
      options = {
        enable = lib.mkEnableOption "Enables ${name} program and related settings.";
      };
      settings = {
        zsh = {
          enable = true;
          aliases = extras.aliases;
        };
      };
      extras = {
        aliases = {
          nrs = "sudo nixos-rebuild switch";
          ls = "ls --color -ah";
          ".." = "cd ..";
          yazi = "y";
          myip = "myip";
        };
      };
    })
  // {
  }))
