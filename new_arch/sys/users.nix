{
  config,
  lib,
  pkgs-list,
  parentPathAsList,
  tools,
  ...
}: let
  ######  # user defined
  name = "users";
  subfolder = null;
  main-repo = "nix";
  branch = "latest";
  imports = null;
  options = {
    enable = lib.mkEnableOption "Enables ${name} related settings.";
  };
  settings = null;
  ######  # computed
  packages =
    if main-repo != null && branch != null
    then pkgs-list.${main-repo}.${branch}
    else null;
  currentPathAsList = parentPathAsList ++ [name];
  currentDirPath = lib.path.subpath.join (lib.lists.flatten ["./." parentPathAsList]);
  cfg = tools.inheritConfig {
    inherit config currentPathAsList;
  };
  inheritedSettings =
    if imports != null || settings != null
    then
      tools.inheritSettings {
        inherit currentPathAsList imports settings;
      }
    else {
    };
  Common =
    inheritedSettings
    // {
    };
  ######  # user defined
  Home = {
  };
  System = {
    users = {
      # mutableUsers = false; # BAZINGA
      defaultUserShell = packages.zsh;
      users = {
        matthieu = {
          # password = ""; # BAZINGA
          # ignoreShellProgramCheck = true; # BAZINGA
          description = "Moi";
          isNormalUser = true;
          group = "users";
          extraGroups = [
            "wheel" # Enable sudo for the user.
            "docker"
            "libvirtd"
          ];
          createHome = true;
          home = "/home/matthieu";
          /*
          openssh.authorizedKeys.keys = [
            ""
          ];
          */
        };
        # root.ignoreShellProgramCheck = true; # BAZINGA
      };
      groups = {
        libvirtd.members = ["matthieu"];
      };
    };
  };
  ######  # computed
  HomeConfig = Common // Home;
  SystemConfig = Common // System;
in {
  config = {
    Home = tools.contextualModule {
      inherit lib config tools; # deps
      inherit subfolder currentPathAsList pkgs-list cfg currentDirPath; # generated
      inherit imports options; # user defined
      context = "Home";
      Config = HomeConfig;
    };
    System = tools.contextualModule {
      inherit lib config tools; # deps
      inherit subfolder currentPathAsList pkgs-list cfg currentDirPath; # generated
      inherit imports options; # user defined
      context = "System";
      Config = SystemConfig;
    };
  };
}
