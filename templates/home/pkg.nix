{
  config,
  lib,
  inputs,
  ...
} @ Inputs: let
  main-repo = "";
  branch = "";
  packages = Inputs.pkgs-list.${main-repo}.${branch};
in {
  options = {};
  imports = [];
  config = {
    home.packages = with packages; [
    ];
  };
}
