{
  config,
  lib,
  inputs,
  ...
} @ Inputs: let
  name = "chromium";
  repo = "nix";
  branch = "latest";
  packages = Inputs.pkgs-list.${repo}.${branch};
  cfg = config.${name};
in {
  options.${name} = {
    enable = lib.mkEnableOption "Enables and configures Chromium.";
  };
  imports = [];
  config = lib.mkIf cfg.enable {
    home.packages = with packages; [
      chromium
    ];
  };
}
