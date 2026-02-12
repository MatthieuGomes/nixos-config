{
  config,
  lib,
  inputs,
  ...
} @ Inputs: let
  packages = Inputs.pkgs-list.nix.latest;
in {
  options = {
  };
  imports = [];
  config = {
    services.printing.enable = true;
    environment.systemPackages = with packages; [
      cnijfilter2
    ];
  };
}
