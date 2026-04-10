{
  config,
  lib,
  pkgs-list,
  ...
} @ Inputs: let
  name = "office";
  subfolder = "office";
  # repo = "";
  # branch = "";
  # packages = pkgs-list.${repo}.${branch};
  options.${name} = {
    enable = lib.mkEnableOption "Enables and configures ${name}";
    libreoffice = lib.mkEnableOption "Enables and configures LibreOffice.";
    qualculate = lib.mkEnableOption "Enables and configures Qualculate.";
  };
  cfg = config.${name};
  settings = {
    libreoffice = {
      enable = cfg.enable && cfg.libreoffice;
    };
    qualculate = {
      enable = cfg.enable && cfg.qualculate;
    };
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
          "libreoffice"
          "qualculate"
        ]
        ++ map (file:
          (import ./${subfolder}/${file}.nix {
            inherit config;
            inherit lib;
            inherit (Inputs) pkgs-list inputs;
          }).config.Home) [];
      config = lib.mkIf cfg.enable {
        inherit (settings) libreoffice qualculate;
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
        # inherit (settings) libreoffice qualculate;
      };
    };
  };
}
