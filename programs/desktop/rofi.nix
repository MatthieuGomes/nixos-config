{
  config,
  lib,
  inputs,
  ...
} @ Inputs: let
  name = "rofi";
  repo = "nix";
  branch = "latest";
  packages = Inputs.pkgs-list.${repo}.${branch};
  cfg = config.${name};
in {
  options.${name} = {
    enable = lib.mkEnableOption "Enables and configures Rofi.";
  };
  imports = [];
  config = lib.mkIf cfg.enable {
    programs.rofi = {
      enable = true;
      terminal = "/${packages.ghostty}/bin/ghostty";
      theme = "Arc-Dark";
      modes = ["drun" "ssh" "run" "calc"];
      plugins = with packages; [
        rofi-calc
      ];
    };
  };
}
