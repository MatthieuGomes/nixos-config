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
    main-repo = "nix";
    branch = "latest";
    options = {
      enable = lib.mkEnableOption "Enables ${name} related settings.";
    };
  };
in (tools.fullModule rec {
  inherit (moduleParams) config lib pkgs-list parentPathAsList tools;
  inherit (moduleParams) name togglable subfolder main-repo branch extras imports specialImports options settings;
  inherit (moduleParams) packages currentPathAsList currentDirPath cfg inheritedSettings Common;
  System = {
    networking = {
      hostName = "NixOs"; # FEAT : make this part of baseSettings
      networkmanager = {
        enable = true;
        plugins = with packages; [
          networkmanager-openvpn
        ];
      };

      firewall = rec {
        enable = true;
        # interfaces."wlp0s20f3".allowedTCPPorts = [10022];
        allowedTCPPorts = [10022 22];
        allowedTCPPortRanges = [
          {
            from = 1714;
            to = 1764;
          }
        ]; # FOR KDE CONNECT TODO: find a better way to do this
        allowedUDPPortRanges = allowedTCPPortRanges; # FOR KDE CONNECT
      };
      # TODO : fix proxy settings
      #   proxy.default = "http://user:password@proxy:port/";
      #   proxy.noProxy = "127.0.0.1,localhost,internal.domain";
    };
    # FEAT : maybe something dedicated to ssh ?
    services = {
      openssh.enable = true;
    }; ## TODO : FIX OPENSSH
    environment.systemPackages = with packages; [
      openvpn
      iproute2
      bridge-utils
    ];
    ## FEAT : maybe move somewhere else ?
  };
})
