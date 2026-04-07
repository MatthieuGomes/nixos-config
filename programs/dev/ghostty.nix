{
  config,
  lib,
  inputs,
  ...
} @ Inputs: let
  name = "ghostty";
  cfg = config.${name};
  options.${name} = {
    enable = lib.mkEnableOption "Enables and configures ${name}";
  };
in {
  config = {
    Home = {
      lib,
      config,
      ...
    }: {
      inherit options;
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
    };
    System = {
      lib,
      config,
      ...
    }: {
      inherit options;
      config =
        lib.mkIf cfg.enable {
        };
    };
  };
}
