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
    name = "networking";
    subfolder = "networking";
    togglable = false;
    main-repo = "nix";
    branch = "latest";
    imports = [
      "vpn"
      "ssh"
    ];
    options = {
      enable = lib.mkEnableOption "Enables ${name} related settings.";
    };
    settings = {
      vpn.enable = true;
      ssh.enable = true;
    };
  };
in (tools.fullModule rec {
  inherit (moduleParams) config lib pkgs-list parentPathAsList tools;
  inherit (moduleParams) name togglable subfolder main-repo branch extras imports specialImports options settings;
  inherit (moduleParams) packages currentPathAsList currentDirPath cfg inheritedSettings Common;
  System = {
    networking = {
      hostName = "NixOs"; # TODO FEAT : make this part of baseSettings
      networkmanager = {
        enable = true;
      };

      firewall = {
        enable = true;
      };
    };
    environment.systemPackages = with packages; [
      iproute2
      bridge-utils
      iw
    ];
  };
})
