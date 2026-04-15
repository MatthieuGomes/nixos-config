{
  config,
  lib,
  pkgs-list,
  parentPathAsList,
  tools,
  ...
}: let
  ######  # user defined
  name = "networking";
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
