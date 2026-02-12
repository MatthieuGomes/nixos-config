{
  config,
  lib,
  inputs,
  ...
} @ Inputs: let
  latest = Inputs.pkgs-list.nix.latest;
in {
  options = {
    fzf = {
      enable = lib.mkEnableOption "Enables and configures fzf for zsh.";
    };
  };
  imports = [];
  config = {
    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
    };
    home.packages = with latest; [
      zsh-fzf-tab
    ];
  };
}
