{
  config,
  lib,
  inputs,
  ...
} @ Inputs: let
  name = "vim";
  main-repo = "nix";
  branch = "latest";
  cfg = config.${name};
in {
  options.${name} = {
    enable = lib.mkEnableOption "Enables and configures Vim.";
  };
  imports = [];
  config = lib.mkIf cfg.enable {
    programs.vim = {
      enable = true;
      defaultEditor = true;
      settings = {
        copyindent = true;
        number = true;
      };
    };
  };
}
