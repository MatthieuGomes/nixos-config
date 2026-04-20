{
  config,
  lib,
  pkgs-list,
  parentPathAsList,
  tools,
  ...
}: let
  moduleParams = tools.moduleParams rec {
    inherit config lib pkgs-list parentPathAsList tools;
    name = "users";
    main-repo = "nix";
    branch = "latest";
    options = {
      enable = lib.mkEnableOption "Enables ${name} related settings.";
    };
  };
in (tools.fullModule rec {
  inherit (moduleParams) config lib pkgs-list parentPathAsList tools;
  inherit (moduleParams) name subfolder main-repo branch extras imports specialImports options settings;
  inherit (moduleParams) packages currentPathAsList currentDirPath cfg inheritedSettings Common;
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
})
