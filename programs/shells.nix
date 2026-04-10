{
  config,
  lib,
  pkgs-list,
  ...
} @ Inputs: let
  folder = "shells";
  aliases = {
    nrs = "sudo nixos-rebuild switch";
    ls = "ls --color -a";
    ".." = "cd ..";
  };
  options.shells = {
    enable = lib.mkEnableOption "Enable various shell configurations.";
    zsh = lib.mkEnableOption "Enable Zsh shell configuration.";
  };
  cfg = config.shells;
  settings = {
    zsh = {
      enable = cfg.enable && cfg.zsh;
      aliases = aliases;
    };
  };
in {
  config = {
    Home = {
      config,
      lib,
      ...
    }: {
      inherit options;
      imports = [
        (import ./${folder}/zsh.nix {
          inherit config;
          inherit lib;
          inherit (Inputs) pkgs-list inputs;
        }).config.Home
      ];
      config = {
        inherit (settings) zsh;
      };
    };
    nixosModule = {
      config,
      lib,
      ...
    }: {
      inherit options;
      imports = [
        (import ./${folder}/zsh.nix {
          inherit config;
          inherit lib;
          inherit (Inputs) pkgs-list inputs;
        }).config.nixosModule
      ];
      config = {
        inherit (settings) zsh;
      };
    };
  };
}
