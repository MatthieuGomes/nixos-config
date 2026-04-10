{
  config,
  lib,
  pkgs-list,
  ...
} @ Inputs: let
  name = "kde";
  subfolder = "kde";
  # repo = "";
  # branch = "";
  # packages = pkgs-list.${repo}.${branch};
  options.${name} = {
    enable = lib.mkEnableOption "Enables and configures ${name}";
    plasma = lib.mkEnableOption "Enables and configures KDE Plasma Desktop.";
    klassy = lib.mkEnableOption "Enables and configures Klassy.";
  };
  cfg = config.${name};
  settings = {
    plasma.enable = cfg.enable && cfg.plasma;
    klassy.enable = cfg.enable && cfg.klassy;
  };
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
          "klassy"
        ]
        ++ map (file:
          (import ./${subfolder}/${file}.nix {
            inherit config;
            inherit lib;
            inherit (Inputs) pkgs-list inputs;
          }).config.Home) [
          "plasma"
        ];
      config = lib.mkIf cfg.enable {
        inherit (settings) plasma klassy;
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
          }).config.nixosModule) [
          "plasma"
        ];
      config = lib.mkIf cfg.enable {
        # inherit (settings);
      };
    };
  };
}
