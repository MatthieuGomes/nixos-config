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
  options = {};
  imports = [];
  config = {
    home.packages = with packages; [
      grub2
    ];
  };
}
