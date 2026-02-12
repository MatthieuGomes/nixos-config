{
  config,
  lib,
  inputs,
  ...
} @ Inputs: let
  name = "efibootmgr";
  main-repo = "nix";
  branch = "latest";
  packages = Inputs.pkgs-list.${main-repo}.${branch};
  cfg = config.${name};
in {
  options.${name} = {
    enable = lib.mkEnableOption "Enables and configures EFIBOOTMGR.";
  };
  imports = [];
  config = lib.mkIf cfg.enable {
    home.packages = with packages; [
      efibootmgr
    ];
  };
}
