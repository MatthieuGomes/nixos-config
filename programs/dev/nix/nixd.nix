{
  config,
  lib,
  inputs,
  ...
} @ Inputs: let
  name = "nixd";
  main-repo = "nix";
  branch = "latest";
  packages = Inputs.pkgs-list.${main-repo}.${branch};
  cfg = config.${name};
  options.${name} = {
    enable = lib.mkEnableOption "Enables and configures Nixd.";
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
        home.packages = with packages; [
          nixd
        ];
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
