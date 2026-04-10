# {
#   config,
#   lib,
#   inputs,
#   ...
# } @ Inputs: let
# in
#   {
#     options = {};
#     imports = map (file: ./desktop/${file}) [
#       "plasma.nix"
#       "rofi.nix"
#       "klassy.nix"
#     ];
#     config = {};
#   }
{
  config,
  lib,
  pkgs-list,
  ...
} @ Inputs: let
  name = "desktop";
  subfolder = "desktop";
  # repo = "";
  # branch = "";
  # packages = pkgs-list.${repo}.${branch};
  options.${name} = {
    enable = lib.mkEnableOption "Enables and configures ${name}";
    plasma = lib.mkEnableOption "Enables and configures KDE Plasma Desktop.";
    klassy = lib.mkEnableOption "Enables and configures Klassy.";
    rofi = lib.mkEnableOption "Enables and configures Rofi.";
  };
  cfg = config.${name};
  settings = {
    plasma.enable = cfg.enable && cfg.plasma;
    klassy.enable = cfg.enable && cfg.klassy;
    rofi.enable = cfg.enable && cfg.rofi;
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
          "rofi"
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
        inherit (settings) rofi plasma klassy;
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
          }).config.nixosModule) ["plasma"];
      config = lib.mkIf cfg.enable {
        inherit (settings) plasma;
      };
    };
  };
}
