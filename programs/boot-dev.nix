{
  config,
  lib,
  inputs,
  ...
} @ Inputs: let
in {
  options = {};
  imports = map (file: ./boot-dev/${file}) [
    "os-prober.nix"
    "efibootmgr.nix"
    "grub.nix"
    "gparted.nix"
  ];
  config = {};
}
