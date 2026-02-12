{
  config,
  lib,
  inputs,
  ...
} @ Inputs: let
  name = "vscode";
  main-repo = "nix";
  branch = "unstable";
  packages = Inputs.pkgs-list.${main-repo}.${branch};
  cfg = config.${name};
in {
  options.${name} = {
    enable = lib.mkEnableOption "Enables and configures VSCode.";
  };
  imports = [];
  config = lib.mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      package = packages.vscode;
      mutableExtensionsDir = true;
      # profiles.Default={

      # };
    };
  };
}
