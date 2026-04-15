# FEAT : unify format
{
  config,
  lib,
  inputs,
  pkgs-list,
  nixos-version,
  baseSettings,
  tools,
  ...
}: let
  name = "home";
  mainModule = "progs"; ## Exceptional structure since home NEEDS to exist but only imports progs
  imports = ["progs"];
in {
  imports = map (file:
    (import ./${mainModule}.nix {
      inherit config lib pkgs-list tools baseSettings;
      inherit inputs;
    }).config.Home)
  imports;

  home.stateVersion = nixos-version;
  home.username = "matthieu";
  home.homeDirectory = "/home/matthieu";
}
