{
  config,
  lib,
  inputs,
  ...
} @ Inputs: let
  name = "git";
  cfg = config.${name};
in {
  options.${name} = {
    enable = lib.mkEnableOption "Enables and configures Git.";
  };
  imports = [];
  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;
      settings = {
        user = {
          name = "MatthieuGomes";
          email = "matthieu.gomes@ensea.fr";
        };
        init.defaultBranch = "main";
      };
    };
  };
}
