{
  config,
  lib,
  inputs,
  ...
} @ Inputs: let
  main-repo = "nix";
  branch = "latest";
  packages = Inputs.pkgs-list.${main-repo}.${branch};
in {
  options.qualculate = {
    enable = lib.mkEnableOption "Enables and configures Qualculate.";
  };
  imports = [];
  config = lib.mkIf config.qualculate.enable {
    home.packages = with packages; [
      qalculate-qt
    ];
  };
}
