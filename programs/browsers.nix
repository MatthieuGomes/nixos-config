{
  config,
  lib,
  pkgs-list,
  ...
} @ Inputs: let
  name = "browsers";
  subfolder = "browsers";
  # repo = "";
  # branch = "";
  # packages = pkgs-list.${repo}.${branch};
  options.${name} = {
    enable = lib.mkEnableOption "Enables and configures ${name}";
    firefox = lib.mkEnableOption "Enables and configures Firefox.";
    chromium = lib.mkEnableOption "Enables and configures Chromium.";
  };
  cfg = config.${name};
  settings = {
    firefox.enable = cfg.enable && cfg.firefox;
    chromium.enable = cfg.enable && cfg.chromium;
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
          "firefox"
          "chromium"
          "zen"
        ]
        ++ map (file:
          (import ./${subfolder}/${file}.nix {
            inherit config;
            inherit lib;
            inherit (Inputs) pkgs-list inputs;
          }).config.Home) [];
      config = lib.mkIf cfg.enable {
        inherit (settings) firefox chromium;
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
        # inherit (settings);
      };
    };
  };
}
