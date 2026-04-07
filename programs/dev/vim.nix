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
  options.${name} = {
    enable = lib.mkEnableOption "Enables and configures Vim.";
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
        programs.vim = {
          enable = true;
          defaultEditor = true;
          settings = {
            copyindent = true;
            number = true;
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
