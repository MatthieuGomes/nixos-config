{
  config,
  lib,
  pkgs-list,
  ...
} @ Inputs: let
in {
  options = {
    oh-my-zsh.enable = lib.mkEnableOption "Enable Oh My Zsh framework.";
  };
  config = lib.mkIf config.oh-my-zsh.enable {
    programs.zsh.oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "sudo"
      ];
    };
  };
}
