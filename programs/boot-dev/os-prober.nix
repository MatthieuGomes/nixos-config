{
  config,
  lib,
  inputs,
  ...
} @ Inputs: let
  packages = Inputs.pkgs-list.nix.latest;
in {
  options = {};
  imports = [];
  config = {
    home.packages = with packages; [
      os-prober
    ];
  };
}
