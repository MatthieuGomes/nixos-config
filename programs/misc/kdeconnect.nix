# {
#   config,
#   lib,
#   inputs,
#   ...
# } @ Inputs: let
#   name = "kdeconnect";
# in
#   {
#     options = {};
#     imports = [];
#     config = {
#       services.${name}.enable = true;
#     };
#   }
{
  config,
  lib,
  pkgs-list,
  ...
} @ Inputs: let
  name = "kdeconnect";
  subfolder = "";
  repo = "nix";
  branch = "latest";
  packages = pkgs-list.${repo}.${branch};
  options.${name} = {
    enable = lib.mkEnableOption "Enables and configures ${name}";
  };
  cfg = config.${name};
  # settings = {
  # };
in {
  config = {
    homeModule = {
      lib,
      config,
      ...
    }: {
      inherit options;
      imports =
        map (file: ./${subfolder}/${file}.nix) [
        ]
        ++ map (file:
          (import ./${subfolder}/${file}.nix {
            inherit config;
            inherit lib;
            inherit (Inputs) pkgs-list inputs;
          }).config.homeModule) [];
      config = lib.mkIf cfg.enable {
        # inherit (settings);
        services.${name}.enable = true;
      };
    };
    nixosModule = {
      lib,
      config,
      ...
    }: {
      inherit options;
      imports =
        map (file: ./${subfolder}/${file}.nix) [
        ]
        ++ map (file:
          (import ./${subfolder}/${file}.nix {
            inherit config;
            inherit lib;
            inherit (Inputs) pkgs-list inputs;
          }).config.nixosModule) [];
      config = lib.mkIf cfg.enable {
        networking.firewall = rec {
          allowedTCPPortRanges = [
            {
              from = 1714;
              to = 1764;
            }
          ]; # FOR KDE CONNECT TODO: find a better way to do this
          allowedUDPPortRanges = allowedTCPPortRanges;
        };
      };
    };
  };
}
