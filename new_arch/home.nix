{
  config,
  lib,
  pkgs-list,
  nixos-version,
  settings,
  tools,
  ...
} @ Inputs: let
  name = "home";
  mainModule = "progs"; ## Exceptional structure since home NEEDS to exist but only imports progs
  imports = ["progs"];

  inheritedSettings = tools.inheritSettings {
    pathNames = [];
    imports = imports;
    settings = settings;
  };
in
  inheritedSettings
  // {
    imports = map (file:
      (import ./${mainModule}.nix {
        inherit config lib pkgs-list tools;
        inherit (Inputs) inputs;
        oldPathNames = [];
      }).config.Home)
    imports;

    home.stateVersion = nixos-version;
    home.username = "matthieu";
    home.homeDirectory = "/home/matthieu";
  }
