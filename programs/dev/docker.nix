{
  config,
  lib,
  pkgs-list,
  ...
} @ Inputs: let
  name = "docker";
  subfolder = "";
  repo = "nix";
  branch = "latest";
  packages = pkgs-list.${repo}.${branch};
  options.${name} = {
    enable = lib.mkEnableOption "Enables and configures ${name}";
  };
  cfg = config.${name};
in {
  config = {
    homeModule = {
      lib,
      config,
      ...
    }: {
      inherit options;
      imports =
        map (file: ./${subfolder}/${file}) [
        ]
        ++ map (file:
          (import ./${subfolder}/${file}.nix {
            inherit config;
            inherit lib;
            inherit (Inputs) pkgs-list inputs;
          }).config.homeModule) [];
      config = lib.mkIf cfg.enable {
        home.packages = with packages; [
          docker-compose
          lazydocker
        ];
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
        virtualisation.docker.enable = true;
      };
    };
  };
}
