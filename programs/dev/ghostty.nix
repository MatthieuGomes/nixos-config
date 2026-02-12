{
  config,
  lib,
  inputs,
  ...
} @ Inputs: let
  name = "ghostty";
  cfg = config.${name};
in {
  options.${name} = {
    enable = lib.mkEnableOption "Enables and configures Ghostty.";
  };
  imports = [];
  config = lib.mkIf cfg.enable {
    programs.ghostty = {
      enable = true;
      enableZshIntegration = true;
      installVimSyntax = true;
      settings = {
        working-directory = "$HOME";
        gtk-single-instance = false;
        window-inherit-working-directory = true;
      };
    };
  };
}
