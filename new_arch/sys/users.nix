{
  config,
  lib,
  pkgs-list,
  parentPathAsList,
  tools,
  ...
} @ Inputs: let
  # Defined by user
  name = "users";
  # subfolder = "";
  main-repo = "nix";
  branch = "latest";
  imports = [];
  options = {
    enable = lib.mkEnableOption "Enables ${name} related settings.";
  };
  #####
  # programmatically generated first
  packages = pkgs-list.${main-repo}.${branch};
  currentPathAsList = parentPathAsList ++ [name];
  currentDirPath = lib.path.subpath.join (lib.lists.flatten ["./." parentPathAsList]);
  cfg = tools.inheritConfig {
    inherit config currentPathAsList;
  };
  Common = {
  };
  #####
  # Second definition by user (can use packages and cfg)
  settings = {};
  Home = {
  };
  System = {
    users = {
      mutableUsers = false; # BAZINGA
      defaultUserShell = packages.zsh;
      users = {
        matthieu = {
          password = ""; # BAZINGA
          ignoreShellProgramCheck = true; # BAZINGA
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
        root.ignoreShellProgramCheck = true; # BAZINGA
      };
      groups = {
        libvirtd.members = ["matthieu"];
      };
    };
  };
  #####
  # programmatically generated then
  HomeConfig = Common // Home;
  SystemConfig = Common // System;
  ###
in {
  config = {
    Home = {
      lib,
      config,
      ...
    }: {
      options = tools.inheritOptions {
        inherit currentPathAsList options;
      };
      config = lib.mkIf cfg.enable HomeConfig;
    };
    System = {
      lib,
      config,
      ...
    }: {
      options = tools.inheritOptions {
        inherit currentPathAsList options;
      };
      config = lib.mkIf cfg.enable SystemConfig;
    };
  };
}
