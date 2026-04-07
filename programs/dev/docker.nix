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
    Home = {
      lib,
      config,
      ...
    }: {
      inherit options;
      config = lib.mkIf cfg.enable {
        home.packages = with packages; [
          docker
          docker-compose
          lazydocker
        ];
      };
    };
    System = {
      lib,
      config,
      ...
    }: {
      inherit options;
      config = lib.mkIf cfg.enable {
        virtualisation.docker.enable = true;
      };
    };
  };
}
