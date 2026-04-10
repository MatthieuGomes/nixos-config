{
  config,
  lib,
  pkgs-list,
  ...
} @ Inputs: let
  name = "firefox";
  subfolder = "";
  # repo = "";
  # branch = "";
  # packages = pkgs-list.${repo}.${branch};
  options.${name} = {
    enable = lib.mkEnableOption "Enables and configures ${name}";
  };
  cfg = config.${name};
  # settings = {
  # };
in {
  config = {
    Home = {
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
          }).config.Home) [];
      config = lib.mkIf cfg.enable {
        # inherit (settings);
      };
    };
    System = {
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
          }).config.System) [];
      config = lib.mkIf cfg.enable {
        # inherit (settings);
        programs.firefox = {
        };
      };
    };
  };
}
