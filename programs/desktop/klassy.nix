{
  config,
  lib,
  inputs,
  ...
} @ Inputs: let
  name = "klassy";
  main-repo = "nur";
  branch = "klassy";
  packages = Inputs.pkgs-list.${main-repo}.${branch};
  cfg = config.${name};
in {
  options.${name} = {
    enable = lib.mkEnableOption "Enables and configures Klassy.";
  };
  imports = [];
  config = lib.mkIf cfg.enable {
    home.packages = with packages.repos; [
      shadowrz.klassy-qt6
    ];
  };
}
