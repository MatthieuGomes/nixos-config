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
    enable = lib.mkEnableOption "Enables and configures user related settings.";
  };
  Common = {
  };
  Home = {
  };
  System = {
    users = {
      defaultUserShell = packages.zsh;
      users = {
        matthieu = {
          description = "Moi";
          isNormalUser = true;
          group = "users";
          extraGroups = [
            "wheel"
            "docker"
            "libvirtd"
          ]; # Enable ‘sudo’ for the user.
          createHome = true;
          home = "/home/matthieu";
          /*
          openssh.authorizedKeys.keys = [
            ""
          ];
          */
        };
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
