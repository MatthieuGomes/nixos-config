{
  config,
  lib,
  inputs,
  ...
} @ Inputs: let
  name = "bambu-studio";
  main-repo = "nix";
  branch = "latest";
  packages = Inputs.pkgs-list.${main-repo}.${branch};
  cfg = config.${name};
in {
  options.${name} = {
    enable = lib.mkEnableOption "Enables and configures ${name}.";
  };
  imports = [];
  config = lib.mkIf cfg.enable {
    home.packages = with packages; [
      bambu-studio
    ];
  };
}
