{
  config,
  lib,
  pkgs-list,
  parentPathAsList,
  tools,
  ...
} @ Inputs: let
  name = "networking";
  main-repo = "nix";
  branch = "latest";
  packages = pkgs-list.${main-repo}.${branch};
  currentPathAsList = parentPathAsList ++ [name];
  cfg = config.sys.${name};
  options = {
    enable = lib.mkEnableOption "Enables ${name} related settings.";
  };
  Common = {
  };
  Home = {
  };
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
  HomeConfig = Common // Home;
  SystemConfig = Common // System;
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
