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
    name = "gparted";
    main-repo = "nix";
    branch = "latest";
    options = {
      enable = lib.mkEnableOption "Enables ${name} program and related settings.";
    };
  };
in (tools.fullModule rec {
  inherit (moduleParams) config lib pkgs-list parentPathAsList tools;
  inherit (moduleParams) name togglable subfolder main-repo branch extras imports specialImports options settings;
  inherit (moduleParams) packages currentPathAsList currentDirPath cfg inheritedSettings Common;
  Home = {
    home.packages = with packages; [
      gparted
    ];
    # NOTE : doesnt work, needs manual file modification
    # xdg.desktopEntries.gparted = {
    #   name = "GParted**";
    #   categories = ["GNOME" "System" "Filesystem"];
    #   comment = "Create, reorganize, and delete partitions";
    #   exec = "sudo ${packages.gparted}/bin/gparted %f";
    # };
    # NOTE : very Hacky workaround
    home.activation = let
      store_path = builtins.replaceStrings ["/"] ["\\/"] "${packages.gparted}";
      gparted_path = "${store_path}\\/bin\\/gparted";
    in {
      ${name} = lib.mkAfter ''
        sed -i 's/Exec=.*/Exec=sudo ${gparted_path} %f/' /home/matthieu/.local/share/applications/gparted.desktop
      '';
    };
  };
  System = {
    security.sudo = {
      enable = true;
      execWheelOnly = true;
      wheelNeedsPassword = true;
      extraRules = [
        {
          users = ["%wheel"];
          host = "ALL";
          runAs = "ALL:ALL";
          commands = [
            {
              command = "${packages.gparted}/bin/gparted";
              options = ["NOPASSWD"];
            }
          ];
        }
      ];
    };
  };
})
