{
  config,
  lib,
  inputs,
  ...
} @ Inputs: let
  repo = "nix";
  branch = "latest";
  packages = Inputs.pkgs-list.${repo}.${branch};
in {
  options = {};
  imports = [];
  config = {
    networking = {
      hostName = "NixOs";
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
    services = {
      openssh.enable = true;
    }; ## TODO : FIX OPENSSH
    environment.systemPackages = with packages; [
      openvpn
      iproute2
      bridge-utils
    ];
  };
}
