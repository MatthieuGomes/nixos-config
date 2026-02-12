{
  config,
  lib,
  inputs,
  ...
} @ Inputs: let
  main-repo = "nur";
  branch = "latest";
  packages = Inputs.pkgs-list.${main-repo}.${branch};
in {
  options = {};
  imports = [];
  config = {
    home.packages = with packages.repos; [
      shadowrz.klassy-qt6
    ];
  };
}
