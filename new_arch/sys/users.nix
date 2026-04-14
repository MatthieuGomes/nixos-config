{
  config,
  lib,
  pkgs-list,
  oldPathNames,
  tools,
  ...
} @ Inputs: let
  name = "users";
  main-repo = "nix";
  branch = "latest";
  packages = pkgs-list.${main-repo}.${branch};
  pathNames = oldPathNames ++ [name];
  fullPath = lib.concatStringsSep "." pathNames;
  cfg = config.sys.${name};
  options.sys.${name} = {
    enable = lib.mkEnableOption "Enables ${name} related settings.";
  };
  Common = {
  };
  Home = {
  };
  System = {
    users = {
      mutableUsers = false; # BAZINGA
      defaultUserShell = packages.zsh;
      users = {
        matthieu = {
          password = "password"; # BAZINGA
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
  HomeConfig = Common // Home;
  SystemConfig = Common // System;
in {
  config = {
    Home = {
      lib,
      config,
      ...
    }: {
      inherit options;
      config = lib.mkIf cfg.enable HomeConfig;
    };
    System = {
      lib,
      config,
      ...
    }: {
      inherit options;
      config = lib.mkIf cfg.enable SystemConfig;
    };
  };
}
