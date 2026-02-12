{
  config,
  lib,
  pkgs-list,
  ...
} @ Inputs: let
  name = "dev-nix";
  subfolder = "nix";
  # repo = "";
  # branch = "";
  # packages = pkgs-list.${repo}.${branch};
  options.${name} = {
    enable = lib.mkEnableOption "Enables and configures ${name}";
    nixd = lib.mkEnableOption "Enables and configures Nixd.";
    alejandra = lib.mkEnableOption "Enables and configures Alejandra.";
  };
  cfg = config.${name};
  settings = {
    nixd.enable = cfg.enable && cfg.nixd;
    alejandra.enable = cfg.enable && cfg.alejandra;
  };
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
          "nixd"
          "alejandra"
        ]
        ++ map (file:
          (import ./${subfolder}/${file}.nix {
            inherit config;
            inherit lib;
            inherit (Inputs) pkgs-list inputs;
          }).config.homeModule) [];
      config = lib.mkIf cfg.enable {
        inherit (settings) nixd alejandra;
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
